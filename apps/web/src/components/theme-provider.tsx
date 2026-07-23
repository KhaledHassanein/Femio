"use client";

import { ThemeProvider as NextThemesProvider } from "next-themes";
import type { ComponentProps } from "react";

// Thin wrapper so the app wires next-themes to the Femio token switch: it stamps
// [data-theme="dark"|"light"] on <html>, which femio.tokens.css + the Tailwind
// darkMode config already key on.
export function ThemeProvider({ children, ...props }: ComponentProps<typeof NextThemesProvider>) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>;
}
