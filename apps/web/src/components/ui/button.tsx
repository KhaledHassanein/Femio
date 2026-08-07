import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

// Femio Button — shadcn structure, styled entirely with Femio semantic tokens
// (no raw hex/px). Accent is reserved for primary CTAs (docs/12). Default height
// 44px meets the WCAG 2.2 AA touch-target minimum. Focus ring comes from the
// global :focus-visible token rule in globals.css.
// Press feedback is on the base, not per-variant, so every button in the app
// answers a touch the same way (P1.28.6). Hover is a mouse affordance and does
// nothing on a phone — before this, tapping a button produced no response at all
// until whatever it triggered finished. `active:` covers touch and mouse alike;
// the scale is `motion-safe:` as well as being caught by the global
// reduced-motion rule in globals.css, because the intent should be readable here.
const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-sm text-sm font-semibold transition-[background-color,border-color,color,transform] duration-fast ease-standard motion-safe:active:scale-[0.98] focus-visible:outline-none disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        primary: "bg-primary-solid text-primary-fg-solid hover:bg-primary-hover active:bg-primary-active",
        accent: "bg-accent-solid text-accent-fg-solid hover:bg-accent-hover active:bg-accent-hover",
        outline:
          "border border-border bg-transparent text-text hover:bg-surface-sunken active:border-border-strong active:bg-surface-sunken",
        ghost: "bg-transparent text-text hover:bg-surface-sunken active:bg-surface-sunken",
      },
      size: {
        sm: "h-9 px-3",
        md: "h-11 px-5",
        lg: "h-12 px-6 text-md",
        icon: "size-11",
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
