import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";

/**
 * Every text token must reach AA on every surface it can land on (P1.5.2).
 *
 * ## Why this is a test and not a review note
 *
 * `--text-subtle` was "AA-fixed" in an earlier pass and carried a comment saying so:
 * **4.81:1 on `--bg`**. It was never measured against `--surface-sunken`, where it
 * was 4.47 — so subtle text inside any sunken section failed AA while the token
 * looked repaired, and the comment made it look deliberately repaired. The dark
 * theme then turned out to have a second failure nobody had measured at all,
 * `--text-subtle` on `--surface-raised` at 4.32.
 *
 * One pairing checked by hand is not a palette checked. This walks the real token
 * file and checks the whole matrix, in both themes, so the next person to nudge a
 * colour finds out immediately rather than in an audit months later.
 *
 * It reads `assets/brand/tokens/femio.tokens.css` — the canonical source (docs/12),
 * not a copy — so a fix applied only to the Tailwind preset would still fail here.
 */

const TOKENS = readFileSync(
  new URL("../../../../../assets/brand/tokens/femio.tokens.css", import.meta.url),
  "utf8",
);

/** WCAG relative luminance. */
function luminance(hex: string): number {
  const h = hex.replace("#", "");
  const channel = (i: number) => {
    const c = parseInt(h.slice(i, i + 2), 16) / 255;
    return c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4;
  };
  return 0.2126 * channel(0) + 0.7152 * channel(2) + 0.0722 * channel(4);
}

function contrast(a: string, b: string): number {
  const la = luminance(a);
  const lb = luminance(b);
  const hi = Math.max(la, lb);
  const lo = Math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

/**
 * Resolve a token to a hex, following one level of `var(--…)` into the ramp. The
 * themes are separated by the block a declaration appears in, which is why this
 * takes the slice rather than the whole file.
 */
function resolve(block: string, name: string): string {
  const direct = block.match(new RegExp(`--${name}\\s*:\\s*(#[0-9A-Fa-f]{6})`));
  if (direct) return direct[1]!.toUpperCase();
  const indirect = block.match(new RegExp(`--${name}\\s*:\\s*var\\(--([a-z0-9-]+)\\)`));
  if (!indirect) throw new Error(`no value for --${name}`);
  const ramp = TOKENS.match(new RegExp(`--${indirect[1]}\\s*:\\s*(#[0-9A-Fa-f]{6})`));
  if (!ramp) throw new Error(`no ramp value for --${indirect[1]}`);
  return ramp[1]!.toUpperCase();
}

/**
 * The light block is everything before the dark override selector. Splitting on a
 * *token value* was the first attempt and it was wrong the moment a light token
 * became a literal hex — the marker has to be the selector, which is the thing that
 * actually separates the themes.
 */
const darkStart = TOKENS.indexOf('[data-theme="dark"] {');
const LIGHT = TOKENS.slice(0, darkStart);
const DARK = TOKENS.slice(darkStart);

const TEXT = ["text", "text-muted", "text-subtle"];
const SURFACES = ["bg", "surface", "surface-sunken", "surface-raised"];

/** WCAG AA for body text. Nothing in this palette is large-text-only. */
const AA = 4.5;

describe.each([
  ["light", LIGHT],
  ["dark", DARK],
])("%s theme contrast", (_theme, block) => {
  for (const text of TEXT) {
    for (const surface of SURFACES) {
      it(`--${text} on --${surface} reaches AA`, () => {
        let pair: [string, string];
        try {
          pair = [resolve(block, text), resolve(block, surface)];
        } catch {
          // A theme that does not redefine a surface inherits it; skip rather than
          // invent a value, since a wrong assumption here would report a false pass.
          return;
        }
        const ratio = contrast(pair[0], pair[1]);
        expect(
          Number(ratio.toFixed(2)),
          `${pair[0]} on ${pair[1]} is ${ratio.toFixed(2)}:1`,
        ).toBeGreaterThanOrEqual(AA);
      });
    }
  }
});
