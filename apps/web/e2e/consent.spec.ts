import { expect, test, type Page } from "@playwright/test";

// ADR-075: the website may measure visits only after consent. Two shapes of server:
//  - no NEXT_PUBLIC_GTM_ID (previews, CI, a declined decision): the page must load no
//    third-party script at all and have no dataLayer;
//  - a container id set: the consent defaults must be in place before the container
//    loads, nothing but the container host may be requested before consent, and a
//    calculator tap must push only the calculator's slug.
// Either way, nothing a visitor typed may ever appear in the dataLayer.

const THIRD_PARTY = /google-analytics\.com|googletagmanager\.com\/gtag|connect\.facebook\.net|facebook\.com\/tr|doubleclick\.net/;

type Entry = Record<string, unknown> | unknown[];

async function dataLayer(page: Page): Promise<Entry[] | null> {
  return page.evaluate(() => {
    const dl = (window as unknown as { dataLayer?: unknown[] }).dataLayer;
    if (!Array.isArray(dl)) return null;
    // `arguments` objects (gtag calls) serialise as arrays-like objects; normalise.
    return dl.map((e) => (e && typeof e === "object" && !Array.isArray(e) && "0" in (e as object) ? Array.from(e as ArrayLike<unknown>) : e)) as Entry[];
  });
}

test("no third-party request fires before consent, on any page", async ({ page }) => {
  const thirdParty: string[] = [];
  page.on("request", (r) => {
    if (THIRD_PARTY.test(r.url())) thirdParty.push(r.url());
  });
  // The container itself (gtm.js) may load when an id is set: it only reads the denied
  // defaults. Block it so the test is deterministic offline, but record the attempt.
  let containerRequested = false;
  await page.route(/googletagmanager\.com\/gtm\.js/, (route) => {
    containerRequested = true;
    return route.abort();
  });

  await page.goto("/ar/calculators/fertile-window");
  await expect(page.getByRole("heading", { level: 1 })).toBeVisible();

  const dl = await dataLayer(page);
  if (dl === null) {
    // No container id: the collection-free shape. Nothing may have been requested.
    expect(containerRequested).toBe(false);
    expect(thirdParty).toEqual([]);
    return;
  }

  // Container id set: the first gtag call is the denied default.
  const consentDefault = dl.find((e) => Array.isArray(e) && e[0] === "consent" && e[1] === "default") as unknown[] | undefined;
  expect(consentDefault, "consent default must be the page's first consent call").toBeTruthy();
  const signals = consentDefault![2] as Record<string, string>;
  for (const key of ["ad_storage", "ad_user_data", "ad_personalization", "analytics_storage"]) expect(signals[key], key).toBe("denied");
  expect(thirdParty, "no analytics or pixel request before consent").toEqual([]);
});

test("a calculator tap pushes only the calculator's slug, never the day", async ({ page }) => {
  await page.route(/googletagmanager\.com/, (route) => route.abort());
  await page.goto("/en/calculators/period");
  const grid = page.getByRole("grid").first();
  await expect(grid).toBeVisible();
  const before = (await dataLayer(page))?.length ?? 0;
  // Today is always a valid tap (the picker marks it with aria-current="date").
  await grid.locator('button[aria-current="date"]').click();

  const dl = await dataLayer(page);
  if (dl === null) return; // collection-free shape: nothing to assert beyond the page working
  const pushed = dl.slice(before).filter((e) => !Array.isArray(e)) as Record<string, unknown>[];
  const used = pushed.find((e) => e.event === "calculator_used");
  expect(used).toEqual({ event: "calculator_used", calculator_slug: "period" });
  const serialised = JSON.stringify(pushed);
  expect(serialised).not.toMatch(/\d{4}-\d{2}-\d{2}/);
});
