import { env } from "@/lib/env";

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

async function query<T>(path: string): Promise<T | null> {
  const b = baseUrl();
  if (!b) return null;
  try {
    const res = await fetch(`${b}${path}`, { next: { revalidate: REVALIDATE_SECONDS } });
    if (!res.ok) return null;
    return (await res.json()) as T;
  } catch {
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

/** A single published doc by slug (null if not found). */
export async function getContentBySlug(
  collection: string,
  locale: string,
  slug: string,
): Promise<ContentDoc | null> {
  // depth=1 so `authors` / `medicalReviewerProfile` come back as people rather
  // than ids — a byline is the whole point of fetching a single document.
  const data = await query<{ docs: ContentDoc[] }>(
    `/api/${collection}?locale=${encodeURIComponent(locale)}&depth=1&limit=1&where[slug][equals]=${encodeURIComponent(slug)}`,
  );
  return data?.docs?.[0] ?? null;
}
