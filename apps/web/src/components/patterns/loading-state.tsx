import * as React from "react";
import { Skeleton } from "@/components/ui/skeleton";
import { cn } from "@/lib/utils";

interface LoadingStateProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Number of body skeleton lines. */
  rows?: number;
  /** Accessible loading label (localized by the caller). */
  label: string;
}

// Skeleton-based loading (never spinners, docs/12). aria-busy + a visually-hidden
// label so assistive tech announces the loading state.
function LoadingState({ rows = 3, label, className, ...props }: LoadingStateProps) {
  return (
    <div aria-busy="true" aria-live="polite" className={cn("flex flex-col gap-3", className)} {...props}>
      <span className="sr-only">{label}</span>
      <Skeleton className="h-6 w-1/3" />
      {Array.from({ length: rows }).map((_, i) => (
        <Skeleton key={i} className="h-4 w-full" />
      ))}
    </div>
  );
}

export { LoadingState };
