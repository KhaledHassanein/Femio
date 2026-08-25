#!/usr/bin/env node
/**
 * Femio token↔preset parity guard (P1.28 cleanup, ADR-054).
 *
 * `--radius-round: 50%` sat in `femio.tokens.css` for months and was never mapped
 * into the Tailwind preset. Two components used `rounded-round`, and **Tailwind
 * emits nothing at all for an unmapped utility** — no build error, no lint error,
 * no failing test. The only symptom was that a radio dot rendered as a square, and
 * it took a screenshot to notice. This turns that class of mistake into a CI
 * failure.
 *
 * It checks one direction on purpose: every token in the CSS must be reachable
 * from Tailwind. The reverse (a preset key with no token) is legitimate — the
 * preset also maps Tailwind's own scales and a few composite values.
 *
 * When a token is genuinely CSS-only — consumed via `var()` in a stylesheet rather
 * than through a utility class — add it to `CSS_ONLY` with the reason. That list is
 * the record of a decision; the failure is the default.
 */
import { readFileSync } from "node:fs";

const TOKENS_CSS = "assets/brand/tokens/femio.tokens.css";
const PRESET = "assets/brand/tokens/femio.tailwind.preset.js";

/**
 * Token families that must appear in the preset, and the theme section each maps
 * into. Colour tokens are deliberately absent: they are mapped semantically
 * (`--primary-soft` → `primary.soft`) rather than by name, so a literal check
 * would be noise. These families are all name-for-name.
 */
const FAMILIES = [
  { prefix: "--radius-", section: "borderRadius" },
  { prefix: "--stroke-", section: "borderWidth" },
  /**
   * The RB-C1 colour families. Colour is *usually* excluded from this guard — the
   * semantic tokens map by meaning (`--primary-soft` → `primary.soft`) so a literal
   * name check would be noise. These four are the exception because they map
   * name-for-name, which means the check is exact rather than approximate.
   *
   * They are also the families most likely to drift: a new log dimension, a seventh
   * chart series or a sixth skin tone is added to the CSS by whoever needs it, and
   * the preset is the step that gets forgotten. That is precisely how
   * `--radius-round` shipped unmapped and rendered a radio dot as a square.
   */
  { prefix: "--log-", section: "colors" },
  { prefix: "--chart-", section: "colors" },
  { prefix: "--confidence-", section: "colors" },
  { prefix: "--skin-", section: "colors" },
  { prefix: "--gradient-", section: "backgroundImage" },
  { prefix: "--shadow-", section: "boxShadow" },
  { prefix: "--z-", section: "zIndex" },
];

/** Tokens consumed only through `var()` in CSS, never as a utility class. */
const CSS_ONLY = new Set([
  // Applied by the global :focus-visible rule in globals.css, not per component.
  "--shadow-focus",
  // The `frost` surface treatment is composed in CSS alongside --frost-blur.
  "--gradient-dawn",
]);

const css = readFileSync(TOKENS_CSS, "utf8");
const preset = readFileSync(PRESET, "utf8");

/**
 * Custom properties declared anywhere in the token file.
 *
 * Not line-anchored: the token file packs several declarations onto one line
 * (`--z-base:0; --z-raised:10; …`), and a `^`-anchored match silently saw only the
 * first of each — the guard under-reported on its own first run. `var()`
 * references are stripped first so a token that is only *used* here is not
 * mistaken for one that is *declared*.
 */
const declared = new Set(
  [...css.replace(/var\(\s*--[a-z0-9-]+/gi, "var(").matchAll(/(--[a-z0-9-]+)\s*:/gi)].map((m) =>
    m[1].toLowerCase(),
  ),
);

if (declared.size === 0) {
  // A guard that finds nothing to scan must fail, not pass.
  console.error(`tokens-parity-lint: no custom properties found in ${TOKENS_CSS}.`);
  process.exit(1);
}

/** Grab one `section: { ... }` block out of the preset and return its text. */
function sectionBody(name) {
  const start = preset.indexOf(`${name}: {`);
  if (start === -1) return null;
  let depth = 0;
  for (let i = preset.indexOf("{", start); i < preset.length; i += 1) {
    if (preset[i] === "{") depth += 1;
    else if (preset[i] === "}") {
      depth -= 1;
      if (depth === 0) return preset.slice(start, i + 1);
    }
  }
  return null;
}

const missing = [];
let checked = 0;

for (const { prefix, section } of FAMILIES) {
  const body = sectionBody(section);
  if (body === null) {
    console.error(`tokens-parity-lint: preset has no "${section}" section — did it get renamed?`);
    process.exit(1);
  }
  for (const token of declared) {
    if (!token.startsWith(prefix) || CSS_ONLY.has(token)) continue;
    checked += 1;
    // The preset may reference the token by `var(--x)` or map its bare name as a key.
    const key = token.slice(prefix.length);
    const referenced =
      body.includes(`var(${token})`) ||
      new RegExp(`(^|[{,\\s])'?"?${key}'?"?\\s*:`, "m").test(body);
    if (!referenced) missing.push({ token, section, key });
  }
}

if (missing.length > 0) {
  console.error(
    `tokens-parity-lint: ${missing.length} token(s) exist in ${TOKENS_CSS} but are not\n` +
      `reachable from Tailwind. An unmapped utility emits NOTHING — no error, just the\n` +
      `wrong result on screen. Map each one in ${PRESET}, or add it to CSS_ONLY in this\n` +
      `file with the reason it is stylesheet-only.\n`,
  );
  for (const m of missing) {
    console.error(`  ${m.token}  →  expected key "${m.key}" in theme.extend.${m.section}`);
  }
  process.exit(1);
}

/* ---------------------------------------------------------------------------
 * Second check: every themed token is redefined for dark.
 *
 * A token declared only in `:root` keeps its light value on a dark background —
 * silently, with no error and no failing test, exactly like an unmapped utility.
 * A chart axis at `--neutral-500` is legible on white and nearly invisible on
 * #211E2E, and the only symptom is a screenshot nobody took.
 *
 * `--skin-*` is exempt by design: skin does not invert, and a dark-mode variant
 * would mean the same character has a different complexion at night.
 * ------------------------------------------------------------------------- */
const THEMED = ["--log-", "--chart-", "--confidence-"];
/**
 * Everything from the `[data-theme="dark"]` *selector* onward.
 *
 * Anchored to a line that starts the rule, not to the first occurrence of the
 * string: the file's own header comment on line 6 mentions `[data-theme="dark"]`,
 * and slicing from there made "the dark block" mean the whole file — so every
 * light-only token counted as themed and the check passed on everything. Found by
 * deliberately deleting a dark token and watching the guard stay green.
 */
const darkMatch = /^\[data-theme="dark"\]\s*\{/m.exec(css);
if (darkMatch === null) {
  console.error('tokens-parity-lint: no [data-theme="dark"] rule found — did the file change shape?');
  process.exit(1);
}
const darkBlock = css.slice(darkMatch.index);
const darkDeclared = new Set(
  [...darkBlock.matchAll(/(--[a-z0-9-]+)\s*:/gi)].map((m) => m[1].toLowerCase()),
);

const unthemed = [...declared].filter(
  (t) => THEMED.some((p) => t.startsWith(p)) && !darkDeclared.has(t),
);

if (unthemed.length > 0) {
  console.error(
    `tokens-parity-lint: ${unthemed.length} token(s) are declared for light and never
` +
      `redefined under [data-theme="dark"]. They will keep their light value on a dark
` +
      `background, which no test can see.
`,
  );
  for (const t of unthemed) console.error(`  ${t}`);
  process.exit(1);
}

console.log(
  `✓ Token parity guard: ${checked} token(s) across ${FAMILIES.length} famil(ies) are all mapped into the Tailwind preset,
` +
    `  and every themed token is redefined for dark.`,
);
