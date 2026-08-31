/**
 * Content sections that exist as routes but have nothing in them yet (R3.7).
 *
 * `payload.glossary` and `payload.faqs` both hold **zero rows**. Their pages
 * render honestly — *"Terms are on the way — check back soon"* — but they were
 * linked from the site header, the site footer **and** `sitemap.ts`, which means
 * two of five content nav links led nowhere and Google was being asked to index
 * both dead ends.
 *
 * On a product whose whole pitch is that it is better sourced than the
 * competition, "check back soon" is not read as *coming soon*. It is read as
 * abandoned, and it is read before any of the 100 reviewed articles are.
 *
 * ## Why a list rather than deleting the links
 *
 * The routes stay live: a deep link still resolves, and the pages are correct — it
 * is the *promotion* of an empty section that is wrong. Naming them in one place
 * means re-enabling is deleting one line here rather than remembering three files,
 * which is exactly the kind of thing that gets remembered in two of them.
 *
 * **Remove an entry the moment its collection has content.** Nothing checks this
 * automatically: the counts live in the CMS database, and a build-time query would
 * make every page render depend on the CMS being reachable.
 */
export const UNPUBLISHED_SECTIONS: readonly string[] = ["/glossary", "/faq"];

/** Whether a path should be hidden from navigation and the sitemap. */
export function isUnpublishedSection(href: string): boolean {
  return UNPUBLISHED_SECTIONS.includes(href);
}
