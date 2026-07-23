import * as React from "react";
import { cn } from "@/lib/utils";

interface ErrorStateProps extends React.HTMLAttributes<HTMLDivElement> {
  icon?: React.ReactNode;
  title: string;
  description?: string;
  action?: React.ReactNode;
}

// Friendly, actionable error surface (docs/12). Announced to assistive tech.
function ErrorState({ icon, title, description, action, className, ...props }: ErrorStateProps) {
  return (
    <div
      role="alert"
      className={cn(
        "flex flex-col items-center gap-3 rounded-md border border-danger-border bg-danger-soft p-10 text-center text-danger-text",
        className,
      )}
      {...props}
    >
      {icon ? (
        <span aria-hidden>{icon}</span>
      ) : null}
      <div className="flex flex-col gap-1">
        <p className="font-semibold">{title}</p>
        {description ? <p className="text-sm opacity-90">{description}</p> : null}
      </div>
      {action}
    </div>
  );
}

export { ErrorState };
