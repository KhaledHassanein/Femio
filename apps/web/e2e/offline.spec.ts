import { expect, test } from "@playwright/test";

// Verifies the offline queue: a period logged while offline is saved locally and
// synced to Supabase when connectivity returns.
test("a period logged offline syncs when back online", async ({ page, context }) => {
  // Onboard to get a session, then open the tracker.
  await page.goto("/en/welcome");
  await page.getByRole("button", { name: /tracking my cycle/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /start using femio/i }).click();
  await expect(page).toHaveURL(/\/en\/dashboard$/);
  await page.getByRole("link", { name: /^track$/i }).click();
  await expect(page).toHaveURL(/\/en\/track$/);
  await expect(page.getByText(/no periods logged yet/i)).toBeVisible();

  // Go offline and log a period (date defaults to today).
  await context.setOffline(true);
  await page.getByRole("button", { name: /^save$/i }).click();
  await expect(page.getByText(/saved offline/i)).toBeVisible();

  // Back online → OfflineSync flushes the queue and the history updates.
  await context.setOffline(false);
  await expect(page.getByText(/no periods logged yet/i)).toBeHidden({ timeout: 25_000 });
});
