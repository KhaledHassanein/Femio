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

export type ContentDoc = {
  id: string;
  title: string;
  slug: string;
  excerpt?: string | null;
  summary?: string | null;
  body?: RichTextValue;
  disclaimerType?: DisclaimerType | null;
  sources?: Source[] | null;
  lastReviewed?: string | null;
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

/** A single published doc by slug (null if not found). */
export async function getContentBySlug(
  collection: string,
  locale: string,
  slug: string,
): Promise<ContentDoc | null> {
  const data = await query<{ docs: ContentDoc[] }>(
    `/api/${collection}?locale=${encodeURIComponent(locale)}&depth=0&limit=1&where[slug][equals]=${encodeURIComponent(slug)}`,
  );
  return data?.docs?.[0] ?? null;
}
