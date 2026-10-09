import type { ContentDoc } from "@/lib/cms/client";

/**
 * Whether a health page may be indexed: it is written in this locale **and** names
 * its clinical reviewer.
 *
 * Until 2026-10-09 every article and condition carried `seo.noIndex: true`,
 * inherited wholesale from the drafting frontmatter (`robots_while_draft`), so
 * Google was told to ignore the whole library while the sitemap listed it, and the
 * pages a clinician had reviewed were hidden with the rest. A named reviewer is the
 * bar a YMYL page has to clear (docs/30_REVAMP, ADR-071); pages without one stay
 * readable and linked, and are indexed the day a reviewer signs them.
 */
export function isIndexable(
  doc: Pick<ContentDoc, "medicalReviewerProfile">,
  translated: boolean,
): boolean {
  return translated && Boolean(doc.medicalReviewerProfile);
}

/** The imported SEO titles end in "| Femio" and the layout appends " — Femio". */
export function contentTitle(doc: Pick<ContentDoc, "title" | "seo">): string {
  return (doc.seo?.seoTitle || doc.title).replace(/\s*[|—–-]\s*Femio\s*$/i, "");
}
