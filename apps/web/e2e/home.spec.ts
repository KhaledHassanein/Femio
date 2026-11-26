import { expect, test } from "@playwright/test";

test("home leads to the app page and to the tool for each goal", async ({ page }) => {
  await page.goto("/en");
  await expect(page.getByRole("heading", { level: 1 })).toBeVisible();
  // The product is the Android app (D8). The primary CTA appears twice by design
  // (hero and close), so take the first.
  await page.getByRole("link", { name: /^get the app$/i }).first().click();
  await expect(page).toHaveURL(/\/en\/app$/);
  await expect(page.getByText(/coming soon/i).first()).toBeVisible();
  // R14.4: a tester or judge finds the test build card, never a dead download button.
  await expect(page.getByRole("heading", { name: /early test build/i })).toBeVisible();

  await page.goto("/en");
  await page.getByRole("link", { name: /track my period/i }).click();
  await expect(page).toHaveURL(/\/en\/calculators\/period$/);
});

test("Arabic home renders right-to-left", async ({ page }) => {
  await page.goto("/ar");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.locator("html")).toHaveAttribute("lang", "ar");
});

// Regression (ADR-074): from 2026-08-22 to 2026-10-28 the i18n config handed next-intl
// `ar-u-nu-latn` as the locale and every internal link on Arabic pages pointed at
// `/ar-u-nu-latn/…`, a 404. Every href must carry a route locale, and a click must land.
test("Arabic links carry the /ar prefix and lead somewhere", async ({ page }) => {
  await page.goto("/ar");
  await expect(page.locator('a[href*="-u-"]')).toHaveCount(0);
  const internal = page.locator('a[href^="/"]');
  expect(await internal.count()).toBeGreaterThan(10);
  for (const href of await internal.evaluateAll((as) => as.map((a) => a.getAttribute("href") ?? ""))) {
    expect(href, href).toMatch(/^\/ar(\/|$|#)/);
  }
  await page.locator('a[href="/ar/calculators"]').first().click();
  await expect(page).toHaveURL(/\/ar\/calculators$/);
  await expect(page.getByRole("heading", { level: 1 })).toBeVisible();
});
