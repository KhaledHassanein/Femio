import { NextResponse } from "next/server";
import { listContent, LIST_FIELDS } from "@/lib/cms/client";
import { routing } from "@/i18n/routing";

/**
 * Which of a persona's foregrounded articles are actually published (P2.3c).
 *
 * ## Why a route and not a fetch from the component
 *
 * The dashboard is a client tree, and the CMS answer is the same for every reader,
 * so asking from the browser would mean either a cross-origin request to the CMS on
 * every dashboard load or a per-reader cache that helps nobody. This runs on the
 * server, reuses `listContent`'s five-minute revalidation, and returns a few strings.
 *
 * ## It cannot leak a draft
 *
 * The CMS access rules restrict unauthenticated callers to published documents and
 * this route sends no credentials, so a draft awaiting clinician approval is simply
 * absent from the answer. That is the property that lets a dashboard name an article
 * before it is approved without ever linking to a page that 404s: the fourteen
 * postpartum drafts contribute nothing here until the reviewer publishes them, and
 * then they appear with no deploy (ADR-032 — publication is the reviewer's decision,
 * and nothing in the app may pre-empt it).
 */

/** Enough for the longest foreground list, and a bound on what a caller can ask. */
const MAX_SLUGS = 12;

export async function GET(request: Request) {
  const params = new URL(request.url).searchParams;

  const requested = params.get("locale");
  const locale = routing.locales.includes(requested as (typeof routing.locales)[number])
    ? requested!
    : routing.defaultLocale;

  const slugs = (params.get("slugs") ?? "")
    .split(",")
    .map((s) => s.trim())
    .filter((s) => /^[a-z0-9-]+$/.test(s))
    .slice(0, MAX_SLUGS);

  if (slugs.length === 0) return NextResponse.json({ articles: [] });

  const published = new Map(
    (await listContent("articles", locale, { fields: LIST_FIELDS })).map((doc) => [doc.slug, doc.title]),
  );

  // The caller's order is the persona's order, so it is preserved rather than the
  // CMS's `-updatedAt`: a reading list is a sequence someone chose, not a feed.
  const articles = slugs
    .filter((slug) => published.has(slug))
    .map((slug) => ({ slug, title: published.get(slug)! }));

  return NextResponse.json({ articles });
}
