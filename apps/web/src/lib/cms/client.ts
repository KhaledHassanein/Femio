import { routing } from "@/i18n/routing";
import articles from "@femio/content/articles.json";
import conditions from "@femio/content/conditions.json";
import faqs from "@femio/content/faqs.json";
import glossary from "@femio/content/glossary.json";
import people from "@femio/content/people.json";

// Published content, read from `packages/content/*.json`, which
// `scripts/content/build-content.mjs` builds from the Markdown guides in
// `docs/content/articles/` (and, for the English bodies the retired CMS reviewed,
// from its last export in `src/content/snapshot/`). A page view, a crawl or a
// sitemap build touches no database. Publishing: set `status: "published"` in the
// guide's front matter, run `pnpm content:build`, commit.

export type LexicalNode = {
  type?: string;
  tag?: string;
  listType?: string;
  text?: string;
  format?: number;
  url?: string;
  fields?: { url?: string; newTab?: boolean };
  children?: LexicalNode[];
};
export type RichTextValue = { root?: LexicalNode } | null;

export type Source = { title: string; url?: string | null; tier?: string | null };
export type DisclaimerType = "general" | "screening" | "emergency" | "none";

/** A public byline: the person shown as author or reviewer (P1.6.6). */
export type Byline = {
  slug: string;
  name: string;
  credentials?: string | null;
  jobTitle?: string | null;
};

/** Search + social overrides authored in the CMS. All optional — the page's own
 *  copy is the fallback, so an unfilled field never produces an empty tag. */
export type SeoFields = {
  seoTitle?: string | null;
  metaDescription?: string | null;
  canonicalOverride?: string | null;
  noIndex?: boolean | null;
  socialTitle?: string | null;
  socialDescription?: string | null;
};

export type ContentDoc = {
  id: string;
  title: string;
  slug: string;
  authors?: Byline[] | null;
  medicalReviewerProfile?: Byline | null;
  firstPublishedAt?: string | null;
  seo?: SeoFields | null;
  excerpt?: string | null;
  summary?: string | null;
  body?: RichTextValue;
  // FAQ (question/answer) and Glossary (term/definition) collections use their own
  // field names instead of title/body.
  question?: string | null;
  answer?: RichTextValue;
  term?: string | null;
  definition?: RichTextValue;
  disclaimerType?: DisclaimerType | null;
  sources?: Source[] | null;
  lastReviewed?: string | null;
  updatedAt?: string | null;
};

// Author / medical-reviewer bio (P1.9b.3b — doc 15 §7/§8). `sameAs` links feed the
// Person schema's professional-profile signals.
export type PersonDoc = {
  id: string;
  name: string;
  slug: string;
  roles?: ("author" | "medical_reviewer")[] | null;
  credentials?: string | null;
  jobTitle?: string | null;
  affiliation?: string | null;
  bio?: RichTextValue;
  sameAs?: { label: string; url: string }[] | null;
  updatedAt?: string | null;
};

type ByLocale<T> = Record<string, T[]>;
const COLLECTIONS: Record<string, ByLocale<ContentDoc>> = {
  articles: articles as unknown as ByLocale<ContentDoc>,
  conditions: conditions as unknown as ByLocale<ContentDoc>,
  faqs: faqs as unknown as ByLocale<ContentDoc>,
  glossary: glossary as unknown as ByLocale<ContentDoc>,
};
const PEOPLE = people as unknown as ByLocale<PersonDoc>;
const DEFAULT_LOCALE = routing.defaultLocale;

/**
 * Payload's `fallback: true`, reproduced: a locale's own translation where one
 * exists, the English document where it does not. Order follows English
 * (most recently updated first), so a translation never reorders a list.
 */
function inLocale<T extends { slug: string }>(
  byLocale: ByLocale<T> | undefined,
  locale: string,
): T[] {
  if (!byLocale) return [];
  const base = byLocale[DEFAULT_LOCALE] ?? [];
  if (locale === DEFAULT_LOCALE) return base;
  const own = new Map((byLocale[locale] ?? []).map((d) => [d.slug, d]));
  return base.map((d) => own.get(d.slug) ?? d);
}

export function cmsEnabled(): boolean {
  return (COLLECTIONS.articles?.[DEFAULT_LOCALE]?.length ?? 0) > 0;
}

/**
 * Kept for callers that distinguish "unavailable" from "not found" (P1.6.16). With
 * content in the build there is no outage to report, so nothing throws it today.
 */
export class CmsUnavailableError extends Error {
  constructor(path: string, cause?: unknown) {
    super(`CMS unavailable for ${path}`);
    this.name = "CmsUnavailableError";
    this.cause = cause;
  }
}

/**
 * The fields a list of articles or conditions renders: a hub card, the sitemap, the
 * dashboard reading list. Never the body. (It was 2.1 MB per uncached list request
 * when this came from the CMS; it still keeps list payloads small.)
 */
export const LIST_FIELDS = ["slug", "title", "excerpt", "summary", "updatedAt"] as const;

function pick(doc: ContentDoc, fields: readonly string[]): ContentDoc {
  const out: Record<string, unknown> = { id: doc.id };
  for (const f of fields) if (f in doc) out[f] = (doc as Record<string, unknown>)[f];
  return out as ContentDoc;
}

/**
 * All published docs in a content collection, for the given locale.
 * Pass `fields` for anything that lists rather than renders a body.
 */
export async function listContent(
  collection: string,
  locale: string,
  opts?: { throwOnFailure?: boolean; fields?: readonly string[] },
): Promise<ContentDoc[]> {
  const docs = inLocale(COLLECTIONS[collection], locale);
  return opts?.fields ? docs.map((d) => pick(d, opts.fields!)) : docs;
}

/** All published author/reviewer bios for the given locale, by name. */
export async function listPeople(
  locale: string,
  _opts?: { throwOnFailure?: boolean },
): Promise<PersonDoc[]> {
  return [...inLocale(PEOPLE, locale)].sort((a, b) => a.name.localeCompare(b.name));
}

/** A single published bio by slug (null if not found). */
export async function getPersonBySlug(locale: string, slug: string): Promise<PersonDoc | null> {
  return inLocale(PEOPLE, locale).find((p) => p.slug === slug) ?? null;
}

/**
 * Which slugs exist in which locale. English is the master, so every published doc
 * counts; any other locale counts only real translations (P1.6.15: a fallback
 * rendering must not be advertised to search engines as Arabic, French or Spanish).
 */
export async function translatedSlugs(
  collection: string,
  _opts?: { throwOnFailure?: boolean },
): Promise<Record<string, Set<string>>> {
  const byLocale = COLLECTIONS[collection] ?? {};
  return Object.fromEntries(
    routing.locales.map((l) => [l, new Set((byLocale[l] ?? []).map((d) => d.slug))]),
  );
}

/** Which locales a document is genuinely written in (P1.6.15). */
export async function availableLocales(collection: string, slug: string): Promise<string[]> {
  const byLocale = await translatedSlugs(collection);
  return routing.locales.filter((l) => byLocale[l]?.has(slug));
}

/** Every published slug in a collection: what `generateStaticParams` prerenders. */
export function allSlugs(collection: string): string[] {
  return (COLLECTIONS[collection]?.[DEFAULT_LOCALE] ?? []).map((d) => d.slug);
}

/** A single published doc by slug (null if not found). */
export async function getContentBySlug(
  collection: string,
  locale: string,
  slug: string,
): Promise<ContentDoc | null> {
  return inLocale(COLLECTIONS[collection], locale).find((d) => d.slug === slug) ?? null;
}
