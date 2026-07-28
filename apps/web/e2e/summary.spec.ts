import { expect, test } from "@playwright/test";

// @live — the doctor-visit summary renders logged data and offers print/PDF.
test("doctor-visit summary renders logged cycle data and a print action @live", async ({ page }) => {
  await page.goto("/en/welcome");
  await page.getByRole("button", { name: /tracking my cycle/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /start using femio/i }).click();
  await expect(page).toHaveURL(/\/en\/dashboard$/);

  // Log a period so the summary has cycle data.
  await page.getByRole("link", { name: /^track$/i }).click();
  await page.getByRole("button", { name: /^save$/i }).click();
  await expect(page.getByRole("heading", { name: /^calendar$/i })).toBeVisible({ timeout: 25_000 });

  // Reach the summary via settings.
  await page.getByRole("link", { name: /^settings$/i }).click();
  await page.getByRole("link", { name: /open summary/i }).click();
  await expect(page).toHaveURL(/\/en\/summary$/);

  await expect(page.getByRole("heading", { name: /doctor-visit summary/i })).toBeVisible();
  await expect(page.getByText(/periods logged/i)).toBeVisible();
  await expect(page.getByRole("button", { name: /print \/ save as pdf/i })).toBeVisible();
  // The compliance disclaimer is present.
  await expect(page.getByText(/not a medical record or clinical advice/i)).toBeVisible();
});
