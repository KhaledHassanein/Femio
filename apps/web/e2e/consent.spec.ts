import { expect, test } from "@playwright/test";
import { completeOnboarding } from "./helpers/onboarding";

// @live — the consent manager writes to the real ledger (throwaway anonymous user).
// P1.20.2: analytics consent must be opt-in, withdrawable, and it must survive a
// reload — a toggle that only looks right in local state would be worse than none.
test("analytics consent is off by default, and can be granted then withdrawn @live", async ({
  page,
}) => {
  await page.goto("/en/welcome");
  await page.getByRole("radio", { name: /tracking my cycle/i }).click();

  // An adult age band, answered rather than skipped. `isMinor(null)` is `true`
  // (persona/minor.ts:43), so a skipped age makes the analytics grant below
  // impossible — the age gate in consent/actions.ts refuses it and no write is
  // ever issued, which is exactly how this test failed: waiting for a POST the
  // product had correctly declined to make.
  await page.getByRole("button", { name: /^25–34$/ }).click();

  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();

  // The consent rows are on step 3 of 4, not step 2 — this walked one step short
  // and inspected the wrong screen. It never failed because the file is @live and
  // CI skipped it (docs/26 §1.2). Every optional row is left unticked here: the
  // whole point of the assertion is that nothing is opted in on our behalf.
  const analyticsRow = page.getByLabel(/allow anonymous product analytics/i);
  await expect(analyticsRow).toBeVisible();
  await expect(analyticsRow).not.toBeChecked();

  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /start using femio/i }).click();
  await expect(page).toHaveURL(/\/en\/dashboard$/);

  await page.goto("/en/settings");
  const toggle = page.getByLabel(/allow anonymous product analytics/i);
  await expect(toggle).toBeVisible({ timeout: 25_000 });
  await expect(toggle).not.toBeChecked(); // never assumed from onboarding

  // The switch updates optimistically, so reloading straight after the click can
  // outrun the insert (it did, against the production build). Wait for the write
  // itself — that is what "persisted" means here.
  const consentWrite = () =>
    page.waitForResponse(
      (r) => r.url().includes("consent_records") && r.request().method() === "POST",
      { timeout: 25_000 },
    );

  // Grant, and prove it persisted rather than living in React state.
  await Promise.all([consentWrite(), toggle.check()]);
  await page.reload();
  await expect(page.getByLabel(/allow anonymous product analytics/i)).toBeChecked({
    timeout: 25_000,
  });

  // Withdraw must be exactly as easy (GDPR Art. 7(3)) and equally durable.
  await Promise.all([
    consentWrite(),
    page.getByLabel(/allow anonymous product analytics/i).uncheck(),
  ]);
  await page.reload();
  await expect(page.getByLabel(/allow anonymous product analytics/i)).not.toBeChecked({
    timeout: 25_000,
  });
});

test("core consent is explained but not switchable @live", async ({ page }) => {
  await completeOnboarding(page);
  // Wait for the session to land before navigating, or /settings redirects to /welcome.
  await expect(page).toHaveURL(/\/en\/dashboard$/);
  await page.goto("/en/settings");

  // Shown as a statement with the honest way out (delete), not a fake switch.
  await expect(page.getByText(/required for femio to work at all/i)).toBeVisible({
    timeout: 25_000,
  });
  await expect(page.getByText(/store my health entries so i can track them\./i)).toBeVisible();
});
