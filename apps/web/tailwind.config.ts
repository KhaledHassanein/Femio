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
  theme: {
    extend: {
      // Point the preset's font families at the self-hosted next/font variables
      // (loaded in the locale layout) while keeping named fallbacks.
      fontFamily: {
        // Latin face first, Arabic face second: the browser falls through per glyph.
        sans: ["var(--font-sans-latin)", "var(--font-plex-arabic)", "system-ui", "sans-serif"],
        display: ["var(--font-display-latin)", "var(--font-naskh)", "Georgia", "serif"],
        arabic: ["var(--font-plex-arabic)", "var(--font-sans-latin)", "sans-serif"],
      },
    },
  },
  plugins: [animate],
};

export default config;
