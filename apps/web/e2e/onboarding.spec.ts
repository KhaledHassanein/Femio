import { expect, test } from "@playwright/test";

// Drives the real flow: onboarding → native anonymous sign-in (live Supabase) →
// consent + persona_state written → dashboard. Creates a throwaway anonymous user.
// @live — drives real anonymous auth against live Supabase; excluded from the
// DB-free CI e2e run (see playwright.config.ts / test:e2e:ci).
test("onboarding reaches the dashboard with app nav @live", async ({ page }) => {
  await page.goto("/en/welcome");

  await page.getByRole("radio", { name: /tracking my cycle/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();

  // Step 2: anonymous is the default choice → continue.
  await page.getByRole("button", { name: /^continue$/i }).click();

  // Step 3: start.
  await page.getByRole("button", { name: /start using femio/i }).click();

  await expect(page).toHaveURL(/\/en\/dashboard$/);
  await expect(page.getByRole("heading", { name: /your dashboard/i })).toBeVisible();
  await expect(page.getByRole("link", { name: /^track$/i })).toBeVisible();

  // The life-stage options are a radio group, not toggle buttons (P1.28.5). This
  // asserts the role directly because both @live specs drive the wizard through
  // it, and neither runs in CI — a silent selector rot here is invisible until
  // someone runs the live suite by hand.
  await page.goto("/en/welcome");
  const options = page.getByRole("radio");
  await expect(options).toHaveCount(4);
  await expect(options.first()).not.toBeChecked();
  await options.first().click();
  await expect(options.first()).toBeChecked();
});
