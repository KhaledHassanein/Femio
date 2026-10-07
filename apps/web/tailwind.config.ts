import type { Config } from "tailwindcss";
import femioPreset from "@femio/tokens/tailwind-preset";
import animate from "tailwindcss-animate";

// Femio design tokens are the single source of truth (docs/12, ADR-006).
// The preset maps semantic CSS custom properties into Tailwind's theme;
// femio.tokens.css is imported once in the root layout so those vars exist.
/**
 * Make opacity modifiers work on token colours (v3, P2 page pass).
 *
 * The preset maps colours to CSS variables (`bg: "var(--bg)"`). Tailwind 3 cannot
 * apply an opacity modifier to a variable it cannot parse, and it does not error:
 * `bg-bg/85`, `bg-surface/90` and `border-border/70` emitted **no CSS at all**, so the
 * sticky headers were transparent and content scrolled visibly beneath them. Only an
 * `@apply` of the same class surfaced it ("class does not exist").
 *
 * Tailwind accepts a function as a colour and hands it the requested opacity. Every
 * `var(...)` colour becomes one, rendering `color-mix(in srgb, var(--x) N%,
 * transparent)` when a modifier is used and the plain variable otherwise. So every
 * token gets working `/NN` modifiers, and nothing without a modifier changes.
 */
type ColorTree = { [key: string]: string | ColorTree | ColorFn };
type ColorFn = (opts: { opacityValue?: string }) => string;

function withOpacity(tree: ColorTree): ColorTree {
  return Object.fromEntries(
    Object.entries(tree).map(([k, v]) => {
      if (typeof v === "string" && v.startsWith("var(")) {
        const fn: ColorFn = ({ opacityValue }) =>
          opacityValue === undefined || opacityValue === "1"
            ? v
            : `color-mix(in srgb, ${v} calc(${opacityValue} * 100%), transparent)`;
        return [k, fn];
      }
      if (v && typeof v === "object") return [k, withOpacity(v as ColorTree)];
      return [k, v];
    }),
  );
}

const preset = femioPreset as unknown as Config & { theme: { extend: { colors: ColorTree } } };
const tokenPreset = {
  ...preset,
  theme: { ...preset.theme, extend: { ...preset.theme.extend, colors: withOpacity(preset.theme.extend.colors) } },
} as unknown as Config;

const config: Config = {
  // femio.tailwind.preset.js is untyped CJS; it is the canonical token→Tailwind map.
  // `tokenPreset` is that map with opacity modifiers made to work (see above).
  presets: [tokenPreset],
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
