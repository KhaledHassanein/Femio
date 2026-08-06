#!/usr/bin/env node
/**
 * Production sitemap check (P1.6.18).
 *
 * WHY THIS EXISTS AND THE E2E TESTS DO NOT SUFFICE: the sitemap went to Google with
 * **zero articles** in it. A CMS blip while the route was generating made the content
 * queries return empty, the route emitted static pages only, and Next cached that 200
 * for an hour. No build failed, no test failed, no page 404'd — the file was simply,
 * quietly wrong, and absence from a sitemap is read by a crawler as a signal about the
 * pages that are missing.
 *
 * Nothing inside a build could have caught it: `NEXT_PUBLIC_CMS_URL` is deliberately
 * unset in CI, so CI's own sitemap correctly contains no articles. The only place the
 * failure is visible is the deployed site, so that is where this looks.
 *
 * Run: node scripts/seo/sitemap-check.mjs [https://femioapp.com]
 */
const SITE = (process.argv[2] ?? process.env.SITE_URL ?? "https://femioapp.com").replace(/\/$/, "");

/** Pages that must never be advertised, with why. */
const MUST_NOT_APPEAR = [
  ["the crisis page (noindex by design)", /\/help-now/],
  ["the draft privacy policy (ADR-015)", /\/privacy$/],
  ["the draft terms (ADR-015)", /\/terms$/],
];

async function main() {
  let res;
  try {
    res = await fetch(`${SITE}/sitemap.xml`, {
      headers: { "user-agent": "Mozilla/5.0 (compatible; FemioSitemapCheck/1.0)" },
      signal: AbortSignal.timeout(30000),
    });
  } catch (err) {
    console.error(`✗ Could not reach ${SITE}/sitemap.xml — ${err.message}`);
    return 1;
  }

  if (!res.ok) {
    // A 5xx here is the *designed* behaviour when the CMS is down (better than a 200
    // that silently omits everything) — but it still needs a human to know.
    console.error(`✗ ${SITE}/sitemap.xml returned HTTP ${res.status}.`);
    console.error("  If the CMS is down this is expected and self-healing; if it persists, investigate.");
    return 1;
  }

  const xml = await res.text();
  const locs = [...xml.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]);
  const problems = [];

  if (locs.length === 0) problems.push("the sitemap contains no <loc> entries at all");

  const articles = locs.filter((u) => /\/learn\/[^/]+$/.test(u));
  const conditions = locs.filter((u) => /\/conditions\/[^/]+$/.test(u));

  // The actual regression: static pages present, content silently absent.
  if (articles.length === 0) {
    problems.push(
      "no article URLs (/learn/{slug}) — the content query returned empty and the route " +
        "emitted static pages only. This is the exact failure this check exists for.",
    );
  }
  if (conditions.length === 0) problems.push("no condition URLs (/conditions/{slug})");

  // Articles are English-only; listing them under other locales advertises duplicate
  // English pages, because Payload falls back (P1.6.15).
  const untranslated = locs.filter((u) => /\/(ar|fr|es)\/(learn|conditions)\/[^/]+$/.test(u));
  if (untranslated.length > 0) {
    problems.push(
      `${untranslated.length} content URL(s) listed under a locale they are not written in, ` +
        `e.g. ${untranslated[0]}`,
    );
  }

  for (const [label, pattern] of MUST_NOT_APPEAR) {
    const hit = locs.find((u) => pattern.test(u));
    if (hit) problems.push(`${label} is in the sitemap: ${hit}`);
  }

  const duplicates = locs.length - new Set(locs).size;
  if (duplicates > 0) problems.push(`${duplicates} duplicate <loc> entrie(s)`);

  if (problems.length > 0) {
    console.error(`✗ Sitemap check failed for ${SITE} (${locs.length} URLs):\n`);
    for (const p of problems) console.error(`  • ${p}`);
    return 1;
  }

  console.log(
    `✓ Sitemap OK for ${SITE}: ${locs.length} URLs — ${articles.length} article(s), ` +
      `${conditions.length} condition(s), no untranslated locales, no excluded pages.`,
  );
  return 0;
}

// `process.exitCode` rather than `process.exit()`: forcing exit while fetch's handles are
// still closing trips libuv's UV_HANDLE_CLOSING assertion on Windows, which returns 127
// and hides the real status from CI.
process.exitCode = await main();
