import type { LexicalNode, RichTextValue } from "./client";

/**
 * Pull question/answer pairs out of an article body for `FAQPage` structured data (P1.6.x).
 *
 * All 31 authored drafts declare `FAQPage` and carry a "Frequently asked questions" section,
 * and none of it was reaching Google — the article page emits MedicalWebPage, Article and
 * BreadcrumbList but never FAQPage, which is the one that earns the expandable FAQ result.
 *
 * The rule is "an H3 whose text ends in a question mark, plus the prose until the next
 * heading". Matching the section heading itself was the obvious alternative and is worse:
 * "Frequently asked questions" is authored copy that differs per locale (Arabic, French and
 * Spanish versions are coming), so it would work in English and silently emit nothing
 * everywhere else. A question mark is the same signal in every locale Femio ships — Arabic's
 * `؟` included.
 *
 * The tradeoff, stated plainly: this also catches a question-shaped H3 outside the FAQ block
 * (there is exactly one today, in `endometriosis.md`). That is acceptable rather than sloppy —
 * Google's requirement is that marked-up Q&A be genuinely present and visible on the page,
 * and such a heading is a real question with a real answer directly beneath it. What would
 * violate the guidance is marking up content the reader cannot see, which this cannot do:
 * every pair here is read straight out of the rendered body.
 */

const QUESTION_MARKS = /[?？؟]\s*$/;

/** Flatten a node's text, ignoring formatting. */
function textOf(node: LexicalNode): string {
  if (typeof node.text === "string") return node.text;
  return (node.children ?? []).map(textOf).join("");
}

/** A node that reads as prose in an answer — paragraphs, lists, quotes. */
function isAnswerNode(node: LexicalNode): boolean {
  return node.type === "paragraph" || node.type === "list" || node.type === "quote";
}

export type FaqEntry = { question: string; answer: string };

export function extractFaqs(body: RichTextValue | undefined): FaqEntry[] {
  const nodes = body?.root?.children ?? [];
  const entries: FaqEntry[] = [];

  for (const [i, node] of nodes.entries()) {
    if (!node || node.type !== "heading" || node.tag !== "h3") continue;

    const question = textOf(node).trim();
    if (!QUESTION_MARKS.test(question)) continue;

    const answerParts: string[] = [];
    for (const next of nodes.slice(i + 1)) {
      if (!next) continue;
      if (next.type === "heading") break;
      if (!isAnswerNode(next)) continue;
      const text = textOf(next).replace(/\s+/g, " ").trim();
      if (text) answerParts.push(text);
    }

    const answer = answerParts.join(" ").trim();
    // A question with no answer beneath it is not an FAQ entry, and Google rejects
    // incomplete pairs — skip rather than emit an empty `acceptedAnswer`.
    if (answer) entries.push({ question, answer });
  }

  return entries;
}
