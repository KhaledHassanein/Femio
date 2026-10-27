/**
 * Which Lexical quotes are red-flag boxes.
 *
 * Articles write their warning-signs box as a quote whose first words are the
 * "seek care" prefix ("Seek care now: Contact local emergency services…"). The renderer
 * (`lexical.tsx`) turns those, and only those, into the danger Alert; any other quote
 * stays a plain blockquote. The prefix is matched per locale because the box in a
 * translated article opens with that language's phrase, so a translation does not
 * silently lose its box. The snapshot holds English only today (100 articles, 80 boxes),
 * so the Arabic, French and Spanish phrases are provisional: when the first translated
 * article lands, copy its real opening words here (a test fails if a box is missed).
 */

/** Opening words of a red-flag box, one entry per locale, without the colon. */
export const RED_FLAG_PREFIXES = [
  "Seek care now",
  "اطلبي الرعاية الآن",
  "Consultez sans attendre",
  "Busca atención ahora",
] as const;

const escapeForRegExp = (word: string) => word.replace(/[.*+?^$()|[\]\\{}]/g, "\\$&");

const PATTERN = new RegExp(
  "^\\s*(?:" + RED_FLAG_PREFIXES.map(escapeForRegExp).join("|") + ")\\s*[:：]",
  "iu",
);

/**
 * True when `text` opens with a red-flag prefix followed by a colon.
 * @param text Plain text of a quote node.
 */
export function isRedFlagText(text: string): boolean {
  return PATTERN.test(text);
}
