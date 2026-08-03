/**
 * Scrub health data out of error reports before they leave the browser (P1.4.2).
 *
 * Sentry is enormously useful and, out of the box, wrong for this product. Its
 * defaults collect the failing **URL**, request **bodies**, **cookies**, and
 * navigation **breadcrumbs** — and on Femio each of those is a health disclosure:
 *
 *   - `/en/learn/endometriosis-symptoms` says what she was reading;
 *   - a failed POST body is literally the symptom, date or note she just entered;
 *   - breadcrumbs replay the same URLs in sequence.
 *
 * The rule from docs/13 §5 is that health data never reaches a third-party
 * processor. Sentry is a processor. So the payload is cut down to what actually
 * helps someone fix a bug: **which route broke, and what the error was.**
 *
 * The key move is normalising URLs to their **route pattern** rather than dropping
 * them. `/en/learn/endometriosis-symptoms` → `/[locale]/learn/[slug]` keeps the
 * debugging value (you know exactly which page failed) and destroys the
 * inference (you cannot tell which article, or which language she reads in).
 */

/** Route segments that are dynamic in the app router, and what to call them. */
const DYNAMIC_SEGMENTS: { at: number; pattern: RegExp; replacement: string }[] = [
  // Every route is locale-prefixed; the locale itself is not sensitive, but it is
  // an extra identifying attribute on an error and is not needed to fix anything.
  { at: 0, pattern: /^(en|ar|fr|es)$/, replacement: "[locale]" },
];

/** Collections whose next path segment is a content slug — i.e. health-revealing. */
const SLUG_PARENTS = new Set(["learn", "conditions", "authors", "glossary", "faq"]);

/**
 * Reduce a URL to a route pattern. Query strings and fragments are dropped
 * entirely: nothing in Femio needs them to debug, and a `?q=` can contain
 * anything a user typed.
 */
export function normalizeUrl(input: string): string {
  let path: string;
  try {
    path = new URL(input, "https://placeholder.invalid").pathname;
  } catch {
    return "[unparseable]";
  }

  const segments = path.split("/").filter(Boolean);
  const out: string[] = [];

  segments.forEach((segment, index) => {
    for (const rule of DYNAMIC_SEGMENTS) {
      if (rule.at === index && rule.pattern.test(segment)) {
        out.push(rule.replacement);
        return;
      }
    }
    const parent = out[out.length - 1];
    if (parent && SLUG_PARENTS.has(parent)) {
      out.push("[slug]");
      return;
    }
    out.push(segment);
  });

  return `/${out.join("/")}`;
}

type ScrubbableEvent = {
  request?: {
    url?: string;
    data?: unknown;
    cookies?: unknown;
    headers?: Record<string, string>;
    query_string?: unknown;
  };
  user?: unknown;
  breadcrumbs?: { data?: Record<string, unknown>; message?: string }[];
  extra?: Record<string, unknown>;
};

/**
 * Strip an error event down to what is safe and useful. Mutates and returns the
 * event, matching Sentry's `beforeSend` contract.
 *
 * `user` is removed outright rather than reduced to an id: Sentry does not need
 * to know *who* hit the bug in order for us to fix it, and a user id joined to a
 * route is the beginning of a profile.
 */
export function scrubEvent<T extends ScrubbableEvent>(event: T): T {
  if (event.request) {
    if (event.request.url) event.request.url = normalizeUrl(event.request.url);
    // The body of a failed health write is the health data itself.
    delete event.request.data;
    delete event.request.cookies;
    delete event.request.query_string;
    if (event.request.headers) {
      const safe: Record<string, string> = {};
      // Only the two headers that ever help diagnose a browser-side failure.
      for (const key of ["user-agent", "content-type"]) {
        const value = event.request.headers[key] ?? event.request.headers[key.toLowerCase()];
        if (value) safe[key] = value;
      }
      event.request.headers = safe;
    }
  }

  delete event.user;

  if (Array.isArray(event.breadcrumbs)) {
    for (const crumb of event.breadcrumbs) {
      // Navigation breadcrumbs replay the URL trail — same disclosure, in sequence.
      if (crumb.data) {
        for (const key of ["url", "from", "to"]) {
          const value = crumb.data[key];
          if (typeof value === "string") crumb.data[key] = normalizeUrl(value);
        }
      }
    }
  }

  // `extra` is free-form by definition, so it cannot be audited — drop it.
  delete event.extra;

  return event;
}
