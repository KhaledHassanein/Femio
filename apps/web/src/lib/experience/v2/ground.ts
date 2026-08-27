/**
 * Cycle phase → the dashboard's ground colour (RB-C4, `docs/29_REBUILD/06` §1).
 *
 * ## The most transferable thing in the teardown
 *
 * Logging one period in Flo repainted the entire screen: peach with no data,
 * teal-mint in the fertile window, with the date-strip numerals recolouring too.
 * No chip, no label — **the background says where she is in her cycle**.
 *
 * We already had `--phase-*` tokens and spent them on a strip. This puts them where
 * Flo puts them, and adds what Flo cannot: the crossfade is `--motion-phase` at
 * 600ms, slower than anything else, because a ground colour that hurries reads as a
 * glitch rather than as scenery.
 *
 * ## Why this is a lib function and not three lines in the component
 *
 * It is a mapping decision, so the Dart client needs the same one, and a component
 * cannot be unit-tested in this repo — the suite is `environment: "node"` with no
 * jsdom, because the discipline here is pure logic in units and screens in
 * Playwright. Putting the decision in a lib keeps it inside that discipline instead
 * of arguing with it.
 *
 * **It returns null more often than not, and that is correct.** A woman whose cycles
 * are too irregular for tier 1 to name a phase gets neutral ground — not a guess and
 * not an apology. An unknown value returns null too, so a future phase name added
 * server-side degrades to plain rather than to a broken gradient.
 */

/** The four cycle phases that have a `--phase-*` token. */
const PHASE_TOKEN: Readonly<Record<string, string>> = {
  menstrual: "--phase-menstrual",
  follicular: "--phase-follicular",
  ovulatory: "--phase-ovulatory",
  luteal: "--phase-luteal",
};

/**
 * The token name for a phase, or null.
 *
 * Takes the raw variable value because that is what arrives — `variables.phase` is
 * a `VariableValue`, so it can legitimately be null or a string tier 1 added after
 * this build shipped.
 */
export function phaseToken(phase: unknown): string | null {
  if (typeof phase !== "string") return null;
  return PHASE_TOKEN[phase] ?? null;
}

/**
 * The full `background-image` for the ground, or null for no ground.
 *
 * A soft radial rather than a flat wash: a whole screen of one colour reads as a
 * theme change, where a gradient from the top reads as light. 14% through
 * `color-mix` keeps it scenery — text contrast is measured against `--bg`, which
 * stays underneath it.
 */
export function groundImage(phase: unknown): string | null {
  const token = phaseToken(phase);
  if (token === null) return null;
  return `radial-gradient(120% 60% at 50% 0%, color-mix(in oklab, var(${token}) 14%, transparent) 0%, transparent 70%)`;
}

/**
 * Strip the `modules.` prefix from a served `labelKey`.
 *
 * A served document carries the full key because it must be self-describing to the
 * Dart client, which has no next-intl namespace concept. `useTranslations` needs a
 * literal namespace — `i18n-client-lint` enforces it so a namespace can be traced
 * to the bundle it ships in — so the prefix comes off in exactly one place.
 */
export function withoutModulesPrefix(key: string): string {
  return key.startsWith("modules.") ? key.slice("modules.".length) : key;
}
