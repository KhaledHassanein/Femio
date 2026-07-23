import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

// Femio Button — shadcn structure, styled entirely with Femio semantic tokens
// (no raw hex/px). Accent is reserved for primary CTAs (docs/12). Default height
// 44px meets the WCAG 2.2 AA touch-target minimum. Focus ring comes from the
// global :focus-visible token rule in globals.css.
const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-sm text-sm font-semibold transition-colors duration-fast focus-visible:outline-none disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        primary: "bg-primary-solid text-primary-fg-solid hover:bg-primary-hover",
        accent: "bg-accent-solid text-accent-fg-solid hover:bg-accent-hover",
        outline: "border border-border bg-transparent text-text hover:bg-surface-sunken",
        ghost: "bg-transparent text-text hover:bg-surface-sunken",
      },
      size: {
        sm: "h-9 px-3",
        md: "h-11 px-5",
        lg: "h-12 px-6 text-md",
      },
    },
    defaultVariants: { variant: "primary", size: "md" },
  },
);

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  { className, variant, size, asChild = false, ...props },
  ref,
) {
  const Comp = asChild ? Slot : "button";
  return <Comp ref={ref} className={cn(buttonVariants({ variant, size, className }))} {...props} />;
});

export { buttonVariants };
