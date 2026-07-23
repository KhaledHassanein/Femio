import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

// The `danger` variant is Femio's red-flag box ("seek care now" — education, never
// triage). Always pass an icon so meaning isn't carried by color alone (docs/12).
const alertVariants = cva("flex gap-3 rounded-md border p-4 text-sm", {
  variants: {
    variant: {
      info: "border-border bg-info-soft text-text",
      success: "border-success bg-success-soft text-success-text",
      warning: "border-warning bg-warning-soft text-warning-text",
      danger: "border-danger-border bg-danger-soft text-danger-text",
    },
  },
  defaultVariants: { variant: "info" },
});

export interface AlertProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof alertVariants> {
  icon?: React.ReactNode;
}

function Alert({ className, variant, icon, children, ...props }: AlertProps) {
  return (
    <div role="alert" className={cn(alertVariants({ variant }), className)} {...props}>
      {icon ? (
        <span className="mt-0.5 shrink-0" aria-hidden>
          {icon}
        </span>
      ) : null}
      <div className="flex flex-col gap-1">{children}</div>
    </div>
  );
}

function AlertTitle({ className, ...props }: React.HTMLAttributes<HTMLParagraphElement>) {
  return <p className={cn("font-semibold", className)} {...props} />;
}

function AlertDescription({ className, ...props }: React.HTMLAttributes<HTMLParagraphElement>) {
  return <p className={cn("opacity-90", className)} {...props} />;
}

export { Alert, AlertTitle, AlertDescription, alertVariants };
