import type { SearchDoc } from "./index.ts";

/**
 * The half of the corpus that lives in code rather than the database (D4).
 *
 * Migration `0022` searches articles, conditions and glossary terms, because those
 * are Payload rows. Femio's tools and calculators are not rows — they are routes —
 * so nothing in Postgres could ever find them, and a search that returns a page
 * *about* the fertile window while failing to return the calculator that computes
 * it has missed the more useful answer.
 *
 * ## Labels come from the caller
 *
 * Every entry's title is an i18n key resolved by the screen, so this module stays
 * free of `next-intl` and can be reasoned about on its own. The keys are the ones
 * `tools-screen.tsx` already uses, deliberately: two lists of the same tools with
 * two sets of names is how a tool ends up called one thing in the launcher and
 * another in search results.
 *
 * ## Keywords are what she would type, not what we call it
 *
 * `/screeners` is filed under "screeners" and searched for as "mood", "anxiety" or
 * "depression". The keyword lists exist to close exactly that gap, and they are
 * English-only on purpose for now — an invented Arabic synonym list would be a
 * guess about a language, and the localised **title** already matches.
 */

type ToolEntry = {
  key: string;
  href: string;
  /** English aliases she might reasonably type. Never displayed. */
  keywords: readonly string[];
};

const TOOLS: readonly ToolEntry[] = [
  // The website's only tools are the calculators; everything else lives in the
  // app, which search sends her to through the calculators' own hand-off cards.
  {
    key: "calculators",
    href: "/calculators",
    keywords: ["due date", "cycle length", "ovulation date", "bmi", "period calculator", "pregnancy test", "pregnancy calendar", "pregnancy weight gain", "contraction timer", "ivf due date"],
  },
];

/**
 * The tool corpus, with titles resolved.
 *
 * `label` returns the localised name for a `tools.*` key, and `note` its one-line
 * description — both already exist in all four locales for the tools screen.
 */
export function toolDocs(
  label: (key: string) => string,
  note: (key: string) => string,
): SearchDoc[] {
  return TOOLS.map((tool) => ({
    id: `tool:${tool.key}`,
    kind: "calculator" as const,
    title: label(tool.key),
    summary: note(tool.key),
    keywords: tool.keywords,
    href: tool.href,
  }));
}

/** Route for a CMS hit. The RPC returns a slug and a kind; the path is ours. */
export function hrefForContent(kind: string, slug: string): string {
  if (kind === "condition") return `/conditions/${slug}`;
  if (kind === "glossary") return `/glossary#${slug}`;
  return `/learn/${slug}`;
}
