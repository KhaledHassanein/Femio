import { expect, test } from "@playwright/test";

test("home leads to the app page and to the tool for each goal", async ({ page }) => {
  await page.goto("/en");
  await expect(page.getByRole("heading", { level: 1 })).toBeVisible();
  // The product is the Android app (D8). The primary CTA appears twice by design
  // (hero and close), so take the first.
  await page.getByRole("link", { name: /^get the app$/i }).first().click();
  await expect(page).toHaveURL(/\/en\/app$/);
  await expect(page.getByText(/coming soon/i).first()).toBeVisible();

  await page.goto("/en");
  await page.getByRole("link", { name: /track my period/i }).click();
  await expect(page).toHaveURL(/\/en\/calculators\/period$/);
});

test("Arabic home renders right-to-left", async ({ page }) => {
  await page.goto("/ar");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.locator("html")).toHaveAttribute("lang", "ar");
});
