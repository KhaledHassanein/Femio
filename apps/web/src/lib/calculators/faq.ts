/**
 * The question-and-answer lists under each calculator (growth pack 04 §3.1).
 *
 * They live in the message catalogs as `calculators.<tool>.faq`, an array of
 * `{ q, a }`. `t.raw()` hands back whatever is in the JSON, so this is the one place
 * that checks the shape: a malformed or missing list yields no FAQ (and no FAQPage
 * markup) rather than a crash or an empty heading on the page.
 */
import { faqPageJsonLd } from "@/lib/seo/jsonld";

export type CalculatorFaqItem = { q: string; a: string };

/** Keeps only well-formed `{ q, a }` entries with text in both fields. */
export function readFaqMessages(raw: unknown): CalculatorFaqItem[] {
  if (!Array.isArray(raw)) return [];
  return raw.flatMap((entry) => {
    if (typeof entry !== "object" || entry === null) return [];
    const { q, a } = entry as Record<string, unknown>;
    return typeof q === "string" && typeof a === "string" && q.trim() !== "" && a.trim() !== ""
      ? [{ q, a }]
      : [];
  });
}

/** FAQPage JSON-LD for a calculator's list, or `null` when there is nothing to describe. */
export function calculatorFaqJsonLd(items: readonly CalculatorFaqItem[]) {
  if (items.length === 0) return null;
  return faqPageJsonLd(items.map(({ q, a }) => ({ question: q, answer: a })));
}
