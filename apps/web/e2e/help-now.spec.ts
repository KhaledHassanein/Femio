import { expect, test } from "@playwright/test";

// Help-now country numbers (R2.4). The global guidance is always visible and comes first;
// a country's numbers appear only after the reader chooses one, so no number is ever
// presented as global.
test("no number shows until a country is chosen; the global guidance is always there", async ({ page }) => {
  await page.goto("/en/help-now");
  await expect(page.getByRole("heading", { level: 1, name: /need help now\?/i })).toBeVisible();
  await expect(page.getByRole("main").getByText(/nearest emergency department/i)).toBeVisible();
  await expect(page.locator('main a[href^="tel:"]')).toHaveCount(0);
  await expect(page.getByRole("button", { name: "Egypt" })).toHaveAttribute("aria-pressed", "false");
  await expect(page.getByRole("button", { name: "Saudi Arabia" })).toBeVisible();
});

test("choosing Egypt shows Egyptian numbers only, emergency apart from support, each with its source", async ({ page }) => {
  await page.goto("/en/help-now");
  await page.getByRole("button", { name: "Egypt" }).click();
  await expect(page.getByRole("button", { name: "Egypt" })).toHaveAttribute("aria-pressed", "true");
  await expect(page.locator('main a[href="tel:123"]')).toBeVisible();
  await expect(page.locator('main a[href="tel:16328"]')).toBeVisible();
  await expect(page.locator('main a[href="tel:15115"]')).toBeVisible();
  await expect(page.locator('main a[href="tel:997"]')).toHaveCount(0);
  await expect(page.getByRole("heading", { name: "Emergency services" })).toBeVisible();
  await expect(page.getByRole("heading", { name: "Support lines" })).toBeVisible();
  await expect(page.getByRole("link", { name: "Source" })).toHaveCount(3);
  // The global text is still on the page after a choice.
  await expect(page.getByRole("main").getByText(/nearest emergency department/i)).toBeVisible();
});

test("choosing Saudi Arabia swaps the list; choosing it again hides it", async ({ page }) => {
  await page.goto("/en/help-now");
  await page.getByRole("button", { name: "Egypt" }).click();
  await page.getByRole("button", { name: "Saudi Arabia" }).click();
  await expect(page.locator('main a[href="tel:997"]')).toBeVisible();
  await expect(page.locator('main a[href="tel:920033360"]')).toBeVisible();
  await expect(page.locator('main a[href="tel:123"]')).toHaveCount(0);
  await page.getByRole("button", { name: "Saudi Arabia" }).click();
  await expect(page.locator('main a[href^="tel:"]')).toHaveCount(0);
});

test("Arabic: RTL, numbers stay left-to-right, and the page is still noindex", async ({ page }) => {
  await page.goto("/ar/help-now");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await page.getByRole("button", { name: "مصر" }).click();
  await expect(page.locator('main a[href="tel:123"]')).toBeVisible();
  await expect(page.getByText("الإسعاف (مصر)")).toBeVisible();
  const robots = await page.locator('meta[name="robots"]').getAttribute("content");
  expect(robots ?? "").toMatch(/noindex/);
});

test.describe("without JavaScript", () => {
  test.use({ javaScriptEnabled: false });
  test("both countries are listed, each under its own name", async ({ page }) => {
    await page.goto("/en/help-now");
    await expect(page.getByRole("main").getByText(/nearest emergency department/i)).toBeVisible();
    await expect(page.locator('main a[href="tel:123"]')).toBeVisible();
    await expect(page.locator('main a[href="tel:997"]')).toBeVisible();
    await expect(page.getByRole("heading", { name: "Egypt" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Saudi Arabia" })).toBeVisible();
  });
});
