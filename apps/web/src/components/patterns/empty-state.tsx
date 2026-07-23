import * as React from "react";
import { cn } from "@/lib/utils";

interface EmptyStateProps extends React.HTMLAttributes<HTMLDivElement> {
  icon?: React.ReactNode;
  title: string;
  description?: string;
  action?: React.ReactNode;
}

// Every list/page ships a designed empty state (docs/12). Calm, not apologetic.
function EmptyState({ icon, title, description, action, className, ...props }: EmptyStateProps) {
  return (
    <div
      className={cn(
        "flex flex-col items-center gap-3 rounded-md border border-border bg-surface p-10 text-center",
        className,
      )}
      {...props}
    >
      {icon ? (
        <span className="text-text-subtle" aria-hidden>
          {icon}
        </span>
      ) : null}
      <div className="flex flex-col gap-1">
        <p className="font-display text-lg text-text">{title}</p>
        {description ? <p className="text-sm text-text-muted">{description}</p> : null}
      </div>
      {action}
    </div>
  );
}

export { EmptyState };
