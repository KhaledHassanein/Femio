import type { SearchDoc, SearchKind } from "./index.ts";
import { hrefForContent } from "./corpus.ts";
import { SEARCH_ALIASES } from "./aliases.ts";

/**
 * The library half of the search corpus, built from published content (P2.2).
 *
 * Search used to call `search_content` in Postgres (migration `0022`). That made
 * every keystroke a Supabase request, which is egress on a plan that had already run
 * out of it, and it failed outright while the project was restricted (2026-10-06).
 * The library now ships inside the web build (`src/content/snapshot/`), so the
 * index is built from the same documents at build time and served as a static file.
 * Searching costs no database request at all.
 *
 * ## What is indexed
 *
 * Title, the one-line summary, and every **section heading** in the body, as
 * keywords. The headings are the article's own table of contents ("When to call
 * your midwife", "Is it safe to take ibuprofen?"), which is close to what someone
 * types, at a fraction of the size of the full text. The body paragraphs are not
 * indexed: 100 articles of prose would make the index around 1.5 MB, which is too
 * much for a phone to download before it can show a result.
 */

/** The fields this module reads. Structural, so it does not import the CMS client. */
export type LibraryNode = { type?: string; text?: string; children?: LibraryNode[] };
export type LibraryEntry = {
  slug: string;
  title?: string | null;
  term?: string | null;
  excerpt?: string | null;
  summary?: string | null;
  body?: { root?: LibraryNode } | null;
};

function textOf(node: LibraryNode): string {
  if (typeof node.text === "string") return node.text;
  return (node.children ?? []).map(textOf).join("");
}

/** The text of every heading in a Lexical body, in order, without duplicates. */
export function headingsOf(body: LibraryEntry["body"]): string[] {
  const out: string[] = [];
  const walk = (node: LibraryNode) => {
    if (node.type === "heading") {
      const text = textOf(node).replace(/\s+/g, " ").trim();
      if (text && !out.includes(text)) out.push(text);
      return;
    }
    for (const child of node.children ?? []) walk(child);
  };
  if (body?.root) walk(body.root);
  return out;
}

function toDoc(kind: SearchKind, entry: LibraryEntry): SearchDoc | null {
  const title = (entry.title ?? entry.term ?? "").trim();
  if (!title || !entry.slug) return null;
  const summary = (entry.excerpt ?? entry.summary ?? "").trim();
  const keywords = [...headingsOf(entry.body), ...(SEARCH_ALIASES[entry.slug] ?? [])];
  return {
    id: `${kind}:${entry.slug}`,
    kind,
    title,
    ...(summary ? { summary } : {}),
    ...(keywords.length ? { keywords } : {}),
    href: hrefForContent(kind, entry.slug),
  };
}

/** Articles, conditions and glossary terms as search documents. */
export function libraryDocs(library: {
  articles: readonly LibraryEntry[];
  conditions: readonly LibraryEntry[];
  glossary: readonly LibraryEntry[];
}): SearchDoc[] {
  return [
    ...library.conditions.map((e) => toDoc("condition", e)),
    ...library.articles.map((e) => toDoc("article", e)),
    ...library.glossary.map((e) => toDoc("glossary", e)),
  ].filter((d): d is SearchDoc => d !== null);
}

/** What `/api/search-index/{locale}` serves. */
export type LibraryIndex = {
  locale: string;
  /**
   * True when no document in this index is a real translation into `locale`: every
   * result is the English original. The screen says so (`0023`'s rule, kept).
   */
  englishOnly: boolean;
  docs: SearchDoc[];
};
