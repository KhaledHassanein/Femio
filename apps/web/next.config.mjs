import createNextIntlPlugin from "next-intl/plugin";
import withSerwistInit from "@serwist/next";

const withNextIntl = createNextIntlPlugin("./src/i18n/request.ts");

const withSerwist = withSerwistInit({
  swSrc: "src/app/sw.ts",
  swDest: "public/sw.js",
  // Disable the SW in dev so HMR isn't intercepted by cached assets.
  disable: process.env.NODE_ENV === "development",
});

const isDev = process.env.NODE_ENV === "development";

/**
 * Origin a Sentry DSN sends to. Duplicated from `lib/observability/dsn.ts`
 * because next.config.mjs is plain ESM loaded before the TS build exists — the
 * unit-tested copy is the reference; this is four lines that must not import.
 */
function sentryOrigin(dsn) {
  if (!dsn) return null;
  try {
    const parsed = new URL(dsn);
    return `${parsed.protocol}//${parsed.hostname}`;
  } catch {
    return null;
  }
}

/**
 * Origins the browser is allowed to talk to. Built from the same public env the
 * app reads, so the policy can never drift from the services actually in use —
 * and an unlisted origin (an injected tracker, an exfiltration endpoint) simply
 * cannot be reached from a Femio page.
 */
function connectSources() {
  const sources = new Set(["'self'"]);

  const supabase = process.env.NEXT_PUBLIC_SUPABASE_URL;
  if (supabase) {
    sources.add(supabase);
    // Realtime/auth use WebSockets against the same host.
    sources.add(supabase.replace(/^https:/, "wss:"));
  }
  // Analytics is EU-hosted and opt-in (ADR-017); listed only once configured.
  const posthog = process.env.NEXT_PUBLIC_POSTHOG_HOST;
  if (posthog) sources.add(posthog);

  // Sentry's EU ingest endpoint. Derived from the DSN rather than hardcoded, so
  // the policy can't drift from the project actually in use — and if the DSN is
  // unparseable we add nothing rather than widening the policy on a guess.
  const sentry = sentryOrigin(process.env.NEXT_PUBLIC_SENTRY_DSN);
  if (sentry) sources.add(sentry);

  return [...sources].join(" ");
}

function imageSources() {
  const sources = new Set(["'self'", "data:", "blob:"]);
  // Published CMS media (P1.9 article images) is served from the CMS origin.
  if (process.env.NEXT_PUBLIC_CMS_URL) sources.add(process.env.NEXT_PUBLIC_CMS_URL);
  return [...sources].join(" ");
}

/**
 * Content-Security-Policy (P1.23 / SECURITY_REVIEW A05).
 *
 * `script-src` keeps `'unsafe-inline'` because Next's App Router ships its
 * hydration payload as inline scripts; the strict alternative is a per-request
 * nonce, which forces every page to render dynamically and would cost the static
 * generation this SEO-first site depends on. That trade is deliberate, and worth
 * revisiting if Next gains static nonces. Everything else is locked down: no
 * plugins, no framing (clickjacking a health app is a real risk), no base-tag
 * rewriting, forms may only post back to us, and connections are limited to the
 * origins above — which is the control that actually matters behind the rule
 * "no health data reaches a third party".
 */
function contentSecurityPolicy() {
  return [
    "default-src 'self'",
    `script-src 'self' 'unsafe-inline'${isDev ? " 'unsafe-eval'" : ""}`,
    "style-src 'self' 'unsafe-inline'",
    `img-src ${imageSources()}`,
    "font-src 'self' data:",
    `connect-src ${connectSources()}`,
    "worker-src 'self' blob:",
    "manifest-src 'self'",
    "media-src 'self'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-src 'none'",
    "frame-ancestors 'none'",
    "upgrade-insecure-requests",
  ].join("; ");
}

const securityHeaders = [
  { key: "Content-Security-Policy", value: contentSecurityPolicy() },
  // Belt and braces with frame-ancestors, for older browsers.
  { key: "X-Frame-Options", value: "DENY" },
  { key: "X-Content-Type-Options", value: "nosniff" },
  // Send the origin cross-site, never the path: a Femio URL can itself disclose
  // what someone was reading (/learn/endometriosis-symptoms is a health inference).
  { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
  // Nothing here needs hardware or location access.
  {
    key: "Permissions-Policy",
    value: "camera=(), microphone=(), geolocation=(), payment=(), usb=(), interest-cohort=()",
  },
  { key: "X-DNS-Prefetch-Control", value: "off" },
  // Two years, subdomains included. `preload` is deliberately omitted: it is a
  // near-irreversible commitment on a domain that isn't final yet (P1.11.GSC).
  { key: "Strict-Transport-Security", value: "max-age=63072000; includeSubDomains" },
];

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  // Don't advertise the framework version to a scanner.
  poweredByHeader: false,
  async headers() {
    return [{ source: "/:path*", headers: securityHeaders }];
  },
};

export default withSerwist(withNextIntl(nextConfig));
