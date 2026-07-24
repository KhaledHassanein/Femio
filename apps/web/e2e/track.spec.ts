import { expect, test } from "@playwright/test";

// @live — logging a period with a flow intensity renders it on the month calendar.
// Exercises P1.13.1 end-to-end against live Supabase (throwaway anonymous user).
test("logging a period with flow shows it on the calendar @live", async ({ page }) => {
  // Onboard → dashboard → tracker.
  await page.goto("/en/welcome");
  await page.getByRole("button", { name: /tracking my cycle/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /start using femio/i }).click();
  await expect(page).toHaveURL(/\/en\/dashboard$/);
  await page.getByRole("link", { name: /^track$/i }).click();
  await expect(page).toHaveURL(/\/en\/track$/);

  // Pick a flow intensity, then save (date defaults to today).
  await page.getByRole("button", { name: /^heavy$/i }).click();
  await expect(page.getByRole("button", { name: /^heavy$/i })).toHaveAttribute("aria-pressed", "true");
  await page.getByRole("button", { name: /^save$/i }).click();

  // The calendar appears with today marked as a period day + heavy flow.
  await expect(page.getByRole("heading", { name: /^calendar$/i })).toBeVisible({ timeout: 25_000 });
  await expect(page.getByLabel(/log a period — heavy/i)).toBeVisible();
});
