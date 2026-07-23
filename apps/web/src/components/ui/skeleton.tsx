import * as React from "react";
import { cn } from "@/lib/utils";

// Loading uses skeletons, never spinners (docs/12). Pulse collapses under
// prefers-reduced-motion via Tailwind's motion-safe handling of animate-pulse.
function Skeleton({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("animate-pulse rounded-sm bg-surface-sunken", className)} {...props} />;
}

export { Skeleton };
