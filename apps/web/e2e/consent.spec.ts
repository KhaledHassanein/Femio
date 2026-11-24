import { expect, test } from "@playwright/test";

// Owner decision 2026-11-24 (amends ADR-075): no tracking tool may learn which health page a
// visitor opened. The website carries no Google Tag Manager, GA4 or Meta pixel: before and
// after the visitor interacts, no request may reach those hosts. (Visit counting is Vercel
// Web Analytics, served from this site's own origin, and AdSense is gated separately.)

const FORBIDDEN_HOSTS = /googletagmanager\.com|google-analytics\.com|analytics\.google\.com|facebook\.com|connect\.facebook\.net|facebook\.net/;

const PAGES = ["/ar", "/en/learn", "/ar/calculators/fertile-window", "/en/calculators/period"];

test("no Tag Manager, GA4 or Meta request is ever made, before or after interaction", async ({ page }) => {
  const forbidden: string[] = [];
  page.on("request", (r) => {
    if (FORBIDDEN_HOSTS.test(new URL(r.url()).hostname)) forbidden.push(r.url());
  });

  for (const path of PAGES) {
    await page.goto(path);
    await expect(page.getByRole("heading", { level: 1 }).first()).toBeVisible();
  }

  // Interaction: tap today on a calculator's calendar (a tap used to be a tracked event).
  await page.goto("/en/calculators/period");
  const grid = page.getByRole("grid").first();
  await expect(grid).toBeVisible();
  await grid.locator('button[aria-current="date"]').click();
  await page.waitForTimeout(500);

  expect(forbidden, "no request to a Google analytics, Tag Manager or Meta host").toEqual([]);
});

test("the page carries no Tag Manager markup and no analytics dataLayer events", async ({ page }) => {
  await page.goto("/en/calculators/period");
  const grid = page.getByRole("grid").first();
  await expect(grid).toBeVisible();
  await grid.locator('button[aria-current="date"]').click();

  const html = await page.content();
  expect(html).not.toMatch(/googletagmanager|GTM-[A-Z0-9]{4,}|fbq\(|connect\.facebook\.net/);

  // A calculator page has no ad script, so no consent defaults either: no dataLayer at all.
  const eventsPushed = await page.evaluate(() => {
    const dl = (window as unknown as { dataLayer?: unknown[] }).dataLayer;
    return Array.isArray(dl) ? dl.filter((e) => e && typeof e === "object" && "event" in (e as object)).length : 0;
  });
  expect(eventsPushed).toBe(0);
});
