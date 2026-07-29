import type { ContentDoc } from "./client";
import { lexicalToPlainText } from "./lexical";

/** Short lede for hub cards: the excerpt (articles) or summary (conditions). */
export function lede(doc: ContentDoc): string | null {
  return doc.excerpt || doc.summary || null;
}

/** ≤160-char meta description: lede, falling back to the body's plain text. */
export function metaDescription(doc: ContentDoc): string {
  return (doc.excerpt || doc.summary || lexicalToPlainText(doc.body ?? null)).slice(0, 160);
}
