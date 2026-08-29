"use client";

import type { ReactNode } from "react";
import { useTranslations } from "next-intl";
import { WifiOff } from "lucide-react";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { useOnline } from "@/lib/offline/use-online";

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
/**
 * A failed read, said honestly — including when the reason is the connection
 * (RB-C7).
 *
 * ## Why the offline case lives here and not in every caller
 *
 * `useSupabaseQuery` reports one `status: "error"` whether the server refused or
 * the train went into a tunnel, so a screen that renders the caller's message
 * tells a woman with no signal that *something went wrong* and offers her a retry
 * that cannot succeed. Every one of the seven screens using this component had
 * that defect, and fixing it in each of them would have meant seven chances to
 * write it differently.
 *
 * So the component asks. When the browser reports no connection it swaps in the
 * offline copy and keeps the retry — she may well be back by the time she taps it,
 * and removing the control would leave her with nothing to do. The visual weight
 * drops from `danger` to `warning`: losing signal is ordinary, and dressing it as
 * an error tells her something is broken when nothing is.
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
  const online = useOnline();
  const t = useTranslations("states");

  return (
    <>
      <h1 className="font-display text-lg text-text">{title}</h1>
      <Alert variant={online ? "danger" : "warning"}>
        <AlertDescription className="flex flex-col items-start gap-3">
          <span className="flex items-start gap-2">
            {online ? null : <WifiOff className="mt-0.5 size-4 shrink-0" aria-hidden />}
            <span>{online ? message : t("offline.message")}</span>
          </span>
          <Button variant="outline" onClick={onRetry}>
            {online ? retryLabel : t("offline.retry")}
          </Button>
        </AlertDescription>
      </Alert>
      {children}
    </>
  );
}
