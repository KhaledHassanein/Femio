import * as React from "react";
import { cn } from "@/lib/utils";

// 44px tall (touch target) and 16px text (avoids iOS zoom). Focus ring comes from
// the global :focus-visible token; we also strengthen the border on focus.
const Input = React.forwardRef<HTMLInputElement, React.InputHTMLAttributes<HTMLInputElement>>(
  function Input({ className, type, ...props }, ref) {
    return (
      <input
        ref={ref}
        type={type}
        className={cn(
          "flex h-12 w-full rounded-md border border-border bg-surface px-4 text-sm text-text transition-colors duration-fast",
          "placeholder:text-text-subtle focus-visible:border-primary focus-visible:outline-none",
          "disabled:cursor-not-allowed disabled:opacity-50",
          className,
        )}
        {...props}
      />
    );
  },
);

export { Input };
