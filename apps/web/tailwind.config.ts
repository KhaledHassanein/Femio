import type { Config } from "tailwindcss";
import femioPreset from "@femio/tokens/tailwind-preset";
import animate from "tailwindcss-animate";

// Femio design tokens are the single source of truth (docs/12, ADR-006).
// The preset maps semantic CSS custom properties into Tailwind's theme;
// femio.tokens.css is imported once in the root layout so those vars exist.
const config: Config = {
  // femio.tailwind.preset.js is untyped CJS; it is the canonical token→Tailwind map.
  presets: [femioPreset as unknown as Config],
  darkMode: ["class", '[data-theme="dark"]'],
  content: ["./src/**/*.{ts,tsx}"],
  plugins: [animate],
};

export default config;
