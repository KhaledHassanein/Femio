/**
 * The closed list of measurement events (ADR-075; 01_ANALYTICS_AND_PIXELS.md §4).
 *
 * `track()` is the ONLY place in the website that pushes to `dataLayer`
 * (`scripts/analytics-lint.mjs` fails the gate on any other push). An event not in
 * the list, a parameter not in its list, or a value that looks like a date, a day
 * count or free text is dropped and, in development, thrown. That is how the promise
 * "never what she typed into a calculator" becomes a test instead of a hope.
 */

/** Every allowed event and the only parameters it may carry. */
export const ALLOWED_EVENTS = {
  femio_page: ["page_type", "page_language"],
  article_read: ["article_slug", "article_locale"],
  calculator_open: ["calculator_slug"],
  calculator_used: ["calculator_slug"],
  get_app_click: ["page_type", "placement"],
  help_now_open: ["country"],
  language_switch: ["from_locale", "to_locale"],
  outbound_source_click: ["source_host"],
} as const;

export type EventName = keyof typeof ALLOWED_EVENTS;
export type EventParams<E extends EventName> = Partial<Record<(typeof ALLOWED_EVENTS)[E][number], string>>;

export const PAGE_TYPES = ["home", "learn", "article", "hub", "calculator", "help", "legal", "app", "search", "other"] as const;
export type PageType = (typeof PAGE_TYPES)[number];

export const PLACEMENTS = ["header", "hero", "inline", "footer", "calculator_result", "handoff"] as const;

/** A value may be a short slug-like token: never a date, a count of days, or prose. */
const MAX_VALUE_LENGTH = 64;
const LOOKS_LIKE_DATE = /\d{4}-\d{2}-\d{2}|\d{1,2}[/.]\d{1,2}[/.]\d{2,4}/;
const LOOKS_LIKE_PROSE = /\s/;
const SLUG_LIKE = /^[a-z0-9][a-z0-9._:-]*$/i;

export function isSafeValue(value: unknown): value is string {
  if (typeof value !== "string" || value.length === 0 || value.length > MAX_VALUE_LENGTH) return false;
  if (LOOKS_LIKE_DATE.test(value) || LOOKS_LIKE_PROSE.test(value)) return false;
  return SLUG_LIKE.test(value);
}

export type DataLayerEntry = { event: EventName } & Record<string, string>;

/**
 * Validates one event against the allow-list. Returns the entry to push, or a reason
 * it was refused. Pure, so the test can cover every branch without a window.
 */
export function buildEntry(event: string, params: Record<string, unknown> = {}): { ok: true; entry: DataLayerEntry } | { ok: false; reason: string } {
  if (!(event in ALLOWED_EVENTS)) return { ok: false, reason: `event "${event}" is not in the allow-list` };
  const allowed: readonly string[] = ALLOWED_EVENTS[event as EventName];
  const entry: DataLayerEntry = { event: event as EventName };
  for (const [key, value] of Object.entries(params)) {
    if (value === undefined || value === null) continue;
    if (!allowed.includes(key)) return { ok: false, reason: `parameter "${key}" is not allowed on "${event}"` };
    if (!isSafeValue(value)) return { ok: false, reason: `parameter "${key}" carries a value that is not a short token` };
    entry[key] = value;
  }
  return { ok: true, entry };
}

type DataLayerWindow = Window & { dataLayer?: unknown[] };

/** Pushes an allowed event; silently a no-op where there is no dataLayer (no container id). */
export function track<E extends EventName>(event: E, params: EventParams<E> = {}): boolean {
  const result = buildEntry(event, params as Record<string, unknown>);
  if (!result.ok) {
    if (process.env.NODE_ENV !== "production") throw new Error(`track: ${result.reason}`);
    return false;
  }
  if (typeof window === "undefined") return false;
  const w = window as DataLayerWindow;
  if (!Array.isArray(w.dataLayer)) return false;
  w.dataLayer.push(result.entry);
  return true;
}

/** Route → page type. The pathname is the locale-prefixed path (`/ar/learn/pcos-signs`). */
export function pageTypeFor(pathname: string): PageType {
  const parts = pathname.split("/").filter(Boolean);
  const [, section, third] = parts;
  if (parts.length <= 1) return "home";
  switch (section) {
    case "learn":
      return third ? "article" : "learn";
    case "conditions":
      return "hub";
    case "calculators":
      return "calculator";
    case "help-now":
      return "help";
    case "privacy":
    case "terms":
    case "editorial-policy":
    case "medical-review":
      return "legal";
    case "app":
      return "app";
    case "search":
      return "search";
    default:
      return "other";
  }
}

/** The host of an outbound link, with a leading `www.` dropped; null for internal or malformed links. */
export function outboundHost(href: string, siteHost: string): string | null {
  try {
    const url = new URL(href);
    if (url.protocol !== "https:" && url.protocol !== "http:") return null;
    const host = url.hostname.replace(/^www\./, "");
    return host === siteHost.replace(/^www\./, "") ? null : host;
  } catch {
    return null;
  }
}
