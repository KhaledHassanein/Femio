/**
 * Ranked search across everything Femio knows how to explain (D4, TD-14).
 *
 * Chapter 04's opening line is the finding: *105 articles, a glossary and a
 * conditions library — and **no way to search any of it***. This is the ranking
 * half, kept pure so it can be tested exhaustively and so the Dart client ranks
 * results the same way. Assembling the corpus is the caller's job.
 *
 * ## Why the corpus is passed in
 *
 * The sources live in different places: the library in a static index fetched on
 * first search (`library.ts`, P2.2), the tools in code with labels from i18n. A module that fetched its own corpus could not
 * be tested without mocking two clients, and would drag framework imports into
 * tier 2. So it ranks what it is given.
 *
 * ## Matching is title-first, and that is a deliberate limit
 *
 * Chapter 04 specifies Postgres full-text per locale, and notes that Arabic needs
 * its own configuration, which is the whole reason it is not a one-line change.
 * That is the right destination and it needs a migration. This ranks over titles,
 * summaries and keywords, which covers the question a woman actually types — she
 * searches for *endometriosis* or *am I pregnant*, not for a phrase in paragraph
 * nine — and it ships without blocking on a deploy. Full-body search replaces the
 * matcher here and leaves the ordering rules intact.
 */

export type SearchKind = "article" | "condition" | "glossary" | "calculator";

export type SearchDoc = {
  id: string;
  kind: SearchKind;
  title: string;
  /** One line, shown under the title. */
  summary?: string;
  /** Extra terms that should match but need not be displayed — synonyms, aliases. */
  keywords?: readonly string[];
  href: string;
};

export type SearchHit = SearchDoc & { score: number };

/**
 * Case-folded, accent-stripped, trimmed.
 *
 * Accent stripping matters for French and Spanish — "fatigue" should find
 * "fatigué". Arabic is left alone beyond case folding, for the same reason
 * `log-search.ts` leaves it alone: its diacritics are not decorative, and
 * stripping them here would be a guess about a language this function cannot see.
 */
function fold(value: string): string {
  return value.normalize("NFD").replace(/[̀-ͯ]/g, "").toLocaleLowerCase().trim();
}

/**
 * Whole-word boundary, so "pms" does not match "symptoms". Every occurrence is
 * tried: "pain" must still find "Cramping pain" after missing inside "Painful".
 */
function wordStarts(haystack: string, needle: string): boolean {
  for (let at = haystack.indexOf(needle); at !== -1; at = haystack.indexOf(needle, at + 1)) {
    if (at === 0 || !/[\p{L}\p{N}]/u.test(haystack[at - 1]!)) return true;
  }
  return false;
}

/**
 * The words of a several-word query that carry meaning. Words under three letters
 * ("am", "I", "is", "في") are dropped: they match nearly everything and say nothing
 * about what she is looking for.
 */
function meaningfulWords(needle: string): string[] {
  return needle.split(/\s+/).filter((w) => [...w].length >= 3);
}

/**
 * Where a kind sits when scores tie.
 *
 * A **condition** outranks an article about it: someone typing "endometriosis"
 * wants the library entry that gathers everything, not whichever article happens
 * to share the word. A **glossary** term outranks a calculator for the same
 * reason — she is asking what something means before she is asking to compute it.
 */
const KIND_WEIGHT: Record<SearchKind, number> = {
  condition: 3,
  glossary: 2,
  article: 1,
  calculator: 0,
};

/**
 * Rank `docs` against `query`.
 *
 * An empty query returns nothing rather than everything: search is an alternative
 * to browsing, not a dump of the library, and returning 105 articles on focus
 * buries the page under a list she did not ask for.
 */
export function search(query: string, docs: readonly SearchDoc[], limit = 20): SearchHit[] {
  const needle = fold(query);
  if (needle.length === 0) return [];

  const hits: SearchHit[] = [];
  for (const doc of docs) {
    const title = fold(doc.title);
    let score = 0;

    // Exact title beats a title prefix beats a word inside the title. The three are
    // genuinely different confidences that she typed the thing she wants.
    if (title === needle) score = 100;
    else if (title.startsWith(needle)) score = 80;
    else if (wordStarts(title, needle)) score = 60;
    else if (title.includes(needle)) score = 40;

    if (score === 0 && doc.keywords?.some((k) => wordStarts(fold(k), needle))) score = 50;
    if (score === 0 && doc.summary && wordStarts(fold(doc.summary), needle)) score = 20;

    // A question rather than a name ("bleeding after birth", "is ibuprofen safe"):
    // every meaningful word starts a word somewhere in the document. Weakest match,
    // so a document that contains the phrase itself always ranks above it.
    if (score === 0) {
      const words = meaningfulWords(needle);
      if (words.length > 1) {
        const text = fold([doc.title, doc.summary ?? "", ...(doc.keywords ?? [])].join(" "));
        if (words.every((w) => wordStarts(text, w))) score = 10;
      }
    }

    if (score > 0) hits.push({ ...doc, score: score + KIND_WEIGHT[doc.kind] });
  }

  return hits.sort((a, b) => b.score - a.score || a.title.localeCompare(b.title)).slice(0, limit);
}

/** The order groups are shown in. Exported so the UI and the tests cannot disagree. */
export const KIND_ORDER: readonly SearchKind[] = ["condition", "article", "glossary", "calculator"];

/** Hits grouped by kind, in display order, preserving rank within each group. */
export function groupByKind(hits: readonly SearchHit[]): { kind: SearchKind; hits: SearchHit[] }[] {
  return KIND_ORDER.map((kind) => ({ kind, hits: hits.filter((h) => h.kind === kind) })).filter(
    (group) => group.hits.length > 0,
  );
}
