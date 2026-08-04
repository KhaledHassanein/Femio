import { env } from "@/lib/env";
import { routing } from "@/i18n/routing";

// Read PUBLISHED content from the Payload CMS REST API (P1.6.2). The CMS access
// rules already restrict unauthenticated callers to published docs, so no auth is
// sent. Every call degrades gracefully: if the CMS URL is unset or the request
// fails, we return empty/null so the public site never breaks.

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

const REVALIDATE_SECONDS = 300; // ISR: refresh published content every 5 min.

function baseUrl(): string | null {
  return env.NEXT_PUBLIC_CMS_URL ? env.NEXT_PUBLIC_CMS_URL.replace(/\/$/, "") : null;
}

export function cmsEnabled(): boolean {
  return baseUrl() !== null;
}

/**
 * The CMS was unreachable or errored — as distinct from "it answered, and there is no
 * such document". Conflating the two is how a transient outage turns a live article
 * into a 404, which is the one failure mode search engines punish: a 404 invites
 * deindexing, a 5xx is understood as temporary and retried (P1.6.16).
 */
export class CmsUnavailableError extends Error {
  constructor(path: string, cause?: unknown) {
    super(`CMS unavailable for ${path}`);
    this.name = "CmsUnavailableError";
    this.cause = cause;
  }
}

async function query<T>(path: string, opts?: { throwOnFailure?: boolean }): Promise<T | null> {
  const b = baseUrl();
  if (!b) return null;
  try {
    const res = await fetch(`${b}${path}`, { next: { revalidate: REVALIDATE_SECONDS } });
    if (!res.ok) {
      if (opts?.throwOnFailure) throw new CmsUnavailableError(path, `HTTP ${res.status}`);
      return null;
    }
    return (await res.json()) as T;
  } catch (err) {
    if (err instanceof CmsUnavailableError) throw err;
    if (opts?.throwOnFailure) throw new CmsUnavailableError(path, err);
    return null;
  }
}

/** All published docs in a content collection, for the given locale. */
export async function listContent(collection: string, locale: string): Promise<ContentDoc[]> {
  const data = await query<{ docs: ContentDoc[] }>(
    `/api/${collection}?locale=${encodeURIComponent(locale)}&depth=0&limit=100&sort=-updatedAt`,
  );
  return data?.docs ?? [];
}

/** All published author/reviewer bios for the given locale. */
export async function listPeople(locale: string): Promise<PersonDoc[]> {
  const data = await query<{ docs: PersonDoc[] }>(
    `/api/people?locale=${encodeURIComponent(locale)}&depth=0&limit=100&sort=name`,
  );
  return data?.docs ?? [];
}

/** A single published bio by slug (null if not found). */
export async function getPersonBySlug(locale: string, slug: string): Promise<PersonDoc | null> {
  const data = await query<{ docs: PersonDoc[] }>(
    `/api/people?locale=${encodeURIComponent(locale)}&depth=0&limit=1&where[slug][equals]=${encodeURIComponent(slug)}`,
  );
  return data?.docs?.[0] ?? null;
}

/**
 * Which locales a document is genuinely written in (P1.6.15).
 *
 * Payload is configured with `fallback: true`, so asking for `locale=ar` on an
 * English-only article returns the **English** text with no indication that it did.
 * That is right for a reader — better to show her something than nothing — and wrong
 * for a search engine: it made `/ar`, `/fr` and `/es` serve identical English copy at
 * indexable URLs that the sitemap advertised. `fallback-locale=none` is the honest
 * question: it returns a null title where no translation exists.
 *
 * Cheap in practice — one request per locale, on the same 5-minute cache as every
 * other CMS read, and only the sitemap and a page's metadata ask.
 */
export async function availableLocales(collection: string, slug: string): Promise<string[]> {
  const byLocale = await translatedSlugs(collection);
  return routing.locales.filter((l) => byLocale[l]?.has(slug));
}

/**
 * Which slugs exist in which locale, one request per locale for the whole collection.
 *
 * The first version asked per document, which read cleanly and was wrong at scale: the
 * sitemap covers every published doc, so 30 articles became ~120 CMS requests per
 * regeneration. Each is a serverless invocation holding a Postgres connection from a
 * **session-mode** pool capped at 15, and it took the CMS API down with
 * `EMAXCONNSESSION` — a self-inflicted outage from a change whose whole purpose was
 * a cleaner sitemap. Asking per *locale* instead answers the same question in four
 * requests regardless of how many articles exist.
 */
export async function translatedSlugs(collection: string): Promise<Record<string, Set<string>>> {
  const pairs = await Promise.all(
    routing.locales.map(async (locale) => {
      const data = await query<{ docs: { slug?: string; title?: string | null }[] }>(
        `/api/${collection}?locale=${encodeURIComponent(locale)}&fallback-locale=none&depth=0&limit=200`,
      );
      // A doc that comes back with no title in this locale exists but is untranslated.
      const slugs = new Set((data?.docs ?? []).filter((d) => d.title && d.slug).map((d) => d.slug!));
      return [locale, slugs] as const;
    }),
  );
  return Object.fromEntries(pairs);
}

/** A single published doc by slug (null if not found). */
export async function getContentBySlug(
  collection: string,
  locale: string,
  slug: string,
): Promise<ContentDoc | null> {
  // depth=1 so `authors` / `medicalReviewerProfile` come back as people rather
  // than ids — a byline is the whole point of fetching a single document.
  // Throws rather than returning null when the CMS is down, so the page can answer 503
  // instead of 404. A published article that 404s during an outage can be dropped from
  // the index; the same request answered 5xx is simply retried.
  const data = await query<{ docs: ContentDoc[] }>(
    `/api/${collection}?locale=${encodeURIComponent(locale)}&depth=1&limit=1&where[slug][equals]=${encodeURIComponent(slug)}`,
    { throwOnFailure: true },
  );
  return data?.docs?.[0] ?? null;
}
