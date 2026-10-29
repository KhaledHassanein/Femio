import createNextIntlPlugin from "next-intl/plugin";

const withNextIntl = createNextIntlPlugin("./src/i18n/request.ts");

const isDev = process.env.NODE_ENV === "development";

/**
 * Origins the browser is allowed to talk to. Built from the same public env the
 * app reads, so the policy can never drift from the services actually in use —
 * and an unlisted origin (an injected tracker, an exfiltration endpoint) simply
 * cannot be reached from a Femio page.
 */
// ADR-075 (2026-10-28): the two origins a visitor's browser may be sent to, each only
// when its id is set in Vercel, so a preview or a site without the ids keeps the
// closed policy. The hosts are Google's documented sets for Tag Manager with GA4 and
// the Meta Pixel inside it, and for AdSense (which also serves its consent dialog).
// The same ids gate the markup (lib/consent, lib/ads); this is the browser-side lock.
const measurementOn = /^GTM-[A-Z0-9]{4,12}$/.test(process.env.NEXT_PUBLIC_GTM_ID ?? "");
const adsOn = /^ca-pub-\d{10,20}$/.test(process.env.NEXT_PUBLIC_ADSENSE_CLIENT ?? "");

const MEASUREMENT = {
  script: ["https://www.googletagmanager.com", "https://connect.facebook.net"],
  connect: ["https://www.googletagmanager.com", "https://*.google-analytics.com", "https://*.analytics.google.com", "https://www.facebook.com"],
  img: ["https://www.googletagmanager.com", "https://*.google-analytics.com", "https://www.facebook.com"],
  frame: ["https://www.googletagmanager.com"],
};
const ADS = {
  script: ["https://pagead2.googlesyndication.com", "https://*.googlesyndication.com", "https://*.doubleclick.net", "https://fundingchoicesmessages.google.com", "https://www.google.com", "https://*.adtrafficquality.google"],
  connect: ["https://pagead2.googlesyndication.com", "https://*.googlesyndication.com", "https://*.doubleclick.net", "https://fundingchoicesmessages.google.com", "https://www.google.com", "https://*.adtrafficquality.google"],
  img: ["https://*.googlesyndication.com", "https://*.doubleclick.net", "https://www.google.com", "https://*.adtrafficquality.google"],
  frame: ["https://*.googlesyndication.com", "https://*.doubleclick.net", "https://www.google.com", "https://fundingchoicesmessages.google.com", "https://*.adtrafficquality.google"],
};

/** The extra hosts for one directive: none, measurement, ads, or both. */
function allowed(directive) {
  return [...(measurementOn ? MEASUREMENT[directive] : []), ...(adsOn ? ADS[directive] : [])];
}

function scriptSources() {
  // `'unsafe-inline'` is explained on contentSecurityPolicy() below.
  return ["'self'", "'unsafe-inline'", ...(isDev ? ["'unsafe-eval'"] : []), ...allowed("script")].join(" ");
}

function connectSources() {
  // The site is static and talks to nobody but itself until an id is set. Any origin
  // added here is a decision for docs/DECISIONS.md: a visitor's request leaves Femio.
  return ["'self'", ...allowed("connect")].join(" ");
}

function imageSources() {
  return ["'self'", "data:", "blob:", ...allowed("img")].join(" ");
}

function frameSources() {
  // No frames at all without the ids: a health site must not be framed, and frames nothing.
  const extra = allowed("frame");
  return extra.length > 0 ? extra.join(" ") : "'none'";
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
    `script-src ${scriptSources()}`,
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
    `frame-src ${frameSources()}`,
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

export default withNextIntl(nextConfig);
