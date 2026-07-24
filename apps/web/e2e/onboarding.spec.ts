import { expect, test } from "@playwright/test";

// Drives the real flow: onboarding → native anonymous sign-in (live Supabase) →
// consent + persona_state written → dashboard. Creates a throwaway anonymous user.
test("onboarding reaches the dashboard with app nav", async ({ page }) => {
  await page.goto("/en/welcome");

  await page.getByRole("button", { name: /tracking my cycle/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();

  // Step 2: anonymous is the default choice → continue.
  await page.getByRole("button", { name: /^continue$/i }).click();

  // Step 3: start.
  await page.getByRole("button", { name: /start using femio/i }).click();

  await expect(page).toHaveURL(/\/en\/dashboard$/);
  await expect(page.getByRole("heading", { name: /your dashboard/i })).toBeVisible();
  await expect(page.getByRole("link", { name: /^track$/i })).toBeVisible();
});
