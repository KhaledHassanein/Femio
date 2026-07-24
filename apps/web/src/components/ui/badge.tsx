import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

// Status is never color-only — pair with an icon/label at the call site (docs/12).
const badgeVariants = cva(
  "inline-flex items-center gap-1 rounded-pill px-3 py-1 text-xs font-medium",
  {
    variants: {
      variant: {
        neutral: "bg-surface-sunken text-text-muted",
        primary: "bg-primary-soft text-primary-soft-text",
        accent: "bg-accent-soft text-accent-soft-text",
        success: "bg-success-soft text-success-text",
        warning: "bg-warning-soft text-warning-text",
        danger: "bg-danger-soft text-danger-text",
      },
    },
    defaultVariants: { variant: "neutral" },
  },
);

export interface BadgeProps
  extends React.HTMLAttributes<HTMLSpanElement>,
    VariantProps<typeof badgeVariants> {}

function Badge({ className, variant, ...props }: BadgeProps) {
  return <span className={cn(badgeVariants({ variant }), className)} {...props} />;
}

export { Badge, badgeVariants };
