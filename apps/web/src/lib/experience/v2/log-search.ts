import { LOG_TERMS, type LogDimension, type LogTerm } from "./vocabulary.ts";

/**
 * Searching and ordering the log vocabulary — tier 2, pure and portable
 * (RB-C6, `docs/29_REBUILD/06` §3).
 *
 * Flo's logging screen searches across every trackable and lets the user reorder
 * and hide categories. Both are worth taking, and both are logic rather than
 * layout, so they live here where they can be tested and where the Dart client
 * gets them for free.
 *
 * ## Search matches the label, not the key
 *
 * `key` is stable storage (`symptom_logs.type`) and is English by construction —
 * `crampsAbdominal` never changes, in any locale. Searching it would mean an
 * Arabic user typing Arabic and matching nothing, so the caller supplies a
 * translated label per term and matching happens over that.
 *
 * That is why `searchTerms` takes a `label` function rather than importing i18n:
 * the module stays framework-free and the tier-1 guard keeps it that way.
 *
 * ## Ordering is a preference, never a restriction
 *
 * Hiding a category hides it **from this screen's default view**. It is not a
 * filter on what she may log, and `searchTerms` deliberately ignores the hidden
 * set — searching finds a hidden term, because she asked for it by name. Product
 * rule 2 in miniature: emphasis is hers to change, availability is not.
 */

/** The dimensions the log screen shows, in their default order. */
export const DEFAULT_DIMENSION_ORDER: readonly LogDimension[] = [
  "symptom",
  "mood",
  "discharge",
  "vital",
  "intercourse",
];

export type CategoryPreference = {
  /** Her order. Unknown or missing dimensions fall back to the default order. */
  order?: readonly LogDimension[];
  /** Collapsed on this screen. Never a restriction on logging. */
  hidden?: readonly LogDimension[];
};

/**
 * Normalise for comparison: case-folded, accent-stripped, whitespace-trimmed.
 *
 * Accent stripping matters for French and Spanish — a user typing "fatigue" should
 * match "fatigué", and one typing "animo" should match "ánimo". Arabic is left
 * alone beyond case folding: its diacritics are not decorative in the same way and
 * stripping them here would be a guess about a language this function cannot see.
 */
function fold(value: string): string {
  return value
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLocaleLowerCase()
    .trim();
}

/**
 * Terms matching `query`, across every dimension.
 *
 * An empty query returns nothing rather than everything: the search field is an
 * alternative to browsing the category cards, not a duplicate of them, and
 * returning 51 terms on focus would bury the cards under a list she did not ask
 * for.
 */
export function searchTerms(
  query: string,
  label: (term: LogTerm) => string,
  terms: readonly LogTerm[] = LOG_TERMS,
): readonly LogTerm[] {
  const needle = fold(query);
  if (needle.length === 0) return [];

  const scored: { term: LogTerm; rank: number }[] = [];
  for (const term of terms) {
    const haystack = fold(label(term));
    const at = haystack.indexOf(needle);
    if (at === -1) continue;
    // A prefix match outranks one in the middle, so typing "cr" puts "cramps"
    // above "back cramps". Ties keep vocabulary order, which is deliberate.
    scored.push({ term, rank: at === 0 ? 0 : 1 });
  }
  return scored.sort((a, b) => a.rank - b.rank).map((s) => s.term);
}

/**
 * The dimensions to render, in her order, with hidden ones separated rather than
 * dropped — the screen still needs to offer them back.
 */
export function orderedDimensions(pref: CategoryPreference = {}): {
  visible: readonly LogDimension[];
  hidden: readonly LogDimension[];
} {
  const hidden = new Set(pref.hidden ?? []);
  const seen = new Set<LogDimension>();
  const ordered: LogDimension[] = [];

  // Her order first, ignoring anything that is not a real dimension — a stale
  // preference from an older build must not drop a category that still exists.
  for (const dimension of pref.order ?? []) {
    if (DEFAULT_DIMENSION_ORDER.includes(dimension) && !seen.has(dimension)) {
      ordered.push(dimension);
      seen.add(dimension);
    }
  }
  // Then anything she has never expressed an opinion about, in default order. A
  // dimension added by a later release appears rather than vanishing.
  for (const dimension of DEFAULT_DIMENSION_ORDER) {
    if (!seen.has(dimension)) ordered.push(dimension);
  }

  return {
    visible: ordered.filter((d) => !hidden.has(d)),
    hidden: ordered.filter((d) => hidden.has(d)),
  };
}

/** Move a dimension one place, for the reorder control. Total — never throws. */
export function moveDimension(
  order: readonly LogDimension[],
  dimension: LogDimension,
  delta: -1 | 1,
): readonly LogDimension[] {
  const from = order.indexOf(dimension);
  if (from === -1) return order;
  const to = from + delta;
  if (to < 0 || to >= order.length) return order;
  const next = [...order];
  const [moved] = next.splice(from, 1);
  next.splice(to, 0, moved!);
  return next;
}
