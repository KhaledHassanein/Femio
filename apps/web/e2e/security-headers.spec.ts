import { expect, test } from "@playwright/test";

// Security headers (P1.23 / SECURITY_REVIEW A05). These are cheap to add and
// easy to lose in a config refactor, so they are pinned here — and because the
// suite runs against `next start`, the CSP is enforced in every other e2e test
// too: a policy that broke sign-in or the service worker would fail those.
test("public pages carry the security headers", async ({ request }) => {
  const res = await request.get("/en");
  const headers = res.headers();

  expect(headers["x-content-type-options"]).toBe("nosniff");
  expect(headers["x-frame-options"]).toBe("DENY");
  expect(headers["referrer-policy"]).toBe("strict-origin-when-cross-origin");
  expect(headers["strict-transport-security"]).toContain("max-age=");
  expect(headers["permissions-policy"]).toContain("geolocation=()");
  // The framework version is not a scanner's business.
  expect(headers["x-powered-by"]).toBeUndefined();
});

test("the CSP blocks framing, plugins and unlisted origins", async ({ request }) => {
  const csp = (await request.get("/en")).headers()["content-security-policy"] ?? "";

  expect(csp).toContain("default-src 'self'");
  expect(csp).toContain("frame-ancestors 'none'"); // clickjacking a health app
  expect(csp).toContain("object-src 'none'");
  expect(csp).toContain("base-uri 'self'");
  expect(csp).toContain("form-action 'self'");
  // connect-src must be an allow-list, never a wildcard: this is the directive
  // standing behind "no health data reaches a third party".
  expect(csp).toMatch(/connect-src [^;]*'self'/);
  expect(csp).not.toMatch(/connect-src [^;]*\*/);

  // The site talks to nobody but itself: connect-src is exactly 'self'.
  expect(csp).toMatch(/connect-src 'self'(;|$)/);

  // `'unsafe-eval'` is granted only to the dev server (React Refresh needs it).
  // The suite runs against the built app (`next start`), which must not carry it.
  expect(csp).not.toContain("'unsafe-eval'");
});

test("a calculator page and the search index are covered too", async ({ request }) => {
  for (const path of ["/en/calculators/period", "/api/search-index/en"]) {
    const headers = (await request.get(path)).headers();
    expect(headers["content-security-policy"], path).toBeTruthy();
    expect(headers["x-content-type-options"], path).toBe("nosniff");
  }
});
