import { expect, test } from "@playwright/test";

// @live — the consent manager writes to the real ledger (throwaway anonymous user).
// P1.20.2: analytics consent must be opt-in, withdrawable, and it must survive a
// reload — a toggle that only looks right in local state would be worse than none.
test("analytics consent is off by default, and can be granted then withdrawn @live", async ({
  page,
}) => {
  await page.goto("/en/welcome");
  await page.getByRole("button", { name: /tracking my cycle/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  // Step 2 shows the consent rows; leave every optional one unticked.
  const analyticsRow = page.getByLabel(/allow anonymous product analytics/i);
  await expect(analyticsRow).not.toBeChecked();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /start using femio/i }).click();
  await expect(page).toHaveURL(/\/en\/dashboard$/);

  await page.goto("/en/settings");
  const toggle = page.getByLabel(/allow anonymous product analytics/i);
  await expect(toggle).toBeVisible({ timeout: 25_000 });
  await expect(toggle).not.toBeChecked(); // never assumed from onboarding

  // Grant, and prove it persisted rather than living in React state.
  await toggle.check();
  await page.reload();
  await expect(page.getByLabel(/allow anonymous product analytics/i)).toBeChecked({
    timeout: 25_000,
  });

  // Withdraw must be exactly as easy (GDPR Art. 7(3)) and equally durable.
  await page.getByLabel(/allow anonymous product analytics/i).uncheck();
  await page.reload();
  await expect(page.getByLabel(/allow anonymous product analytics/i)).not.toBeChecked({
    timeout: 25_000,
  });
});

test("core consent is explained but not switchable @live", async ({ page }) => {
  await page.goto("/en/welcome");
  await page.getByRole("button", { name: /tracking my cycle/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /start using femio/i }).click();
  // Wait for the session to land before navigating, or /settings redirects to /welcome.
  await expect(page).toHaveURL(/\/en\/dashboard$/);
  await page.goto("/en/settings");

  // Shown as a statement with the honest way out (delete), not a fake switch.
  await expect(page.getByText(/required for femio to work at all/i)).toBeVisible({
    timeout: 25_000,
  });
  await expect(page.getByText(/store my health entries so i can track them\./i)).toBeVisible();
});
