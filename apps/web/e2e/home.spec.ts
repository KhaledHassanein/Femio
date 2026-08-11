import { expect, test } from "@playwright/test";

test("home renders and links into onboarding", async ({ page }) => {
  await page.goto("/en");
  await expect(page.getByRole("heading", { level: 1 })).toBeVisible();
  // The primary CTA appears twice by design — hero and close. Same action, not two
  // competing ones (R1.3, docs/25 §5a), so take the first.
  await page.getByRole("link", { name: /start free/i }).first().click();
  await expect(page).toHaveURL(/\/en\/welcome$/);
  await expect(page.getByText(/where are you in your health journey/i)).toBeVisible();
});

test("Arabic home renders right-to-left", async ({ page }) => {
  await page.goto("/ar");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.locator("html")).toHaveAttribute("lang", "ar");
});
