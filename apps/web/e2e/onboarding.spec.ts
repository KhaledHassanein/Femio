import { expect, test } from "@playwright/test";
import { completeOnboarding } from "./helpers/onboarding";

// Drives the real flow: onboarding → native anonymous sign-in (live Supabase) →
// consent + persona_state written → dashboard. Creates a throwaway anonymous user.
// @live — drives real anonymous auth against live Supabase.
test("onboarding reaches the dashboard with app nav @live", async ({ page }) => {
  await completeOnboarding(page);

  await expect(page.getByRole("heading", { name: /your dashboard/i })).toBeVisible();
  await expect(page.getByRole("link", { name: /^track$/i })).toBeVisible();
});

// The life-stage options are a radio group, not toggle buttons (P1.28.5), and
// there are six of them since the teen and postpartum tracks landed.
//
// This assertion was `toHaveCount(4)` and would have failed against the shipped
// wizard — it never ran, because the whole file was excluded from CI by its
// `@live` tag (docs/26 §9). The count is asserted exactly rather than loosely on
// purpose: a life stage silently disappearing from onboarding is a whole persona
// becoming unreachable, which is precisely the class of bug that produced a teen
// falling through to the adult cycle dashboard before R2.5c.
test("the wizard offers every life stage as a radio group @live", async ({ page }) => {
  await page.goto("/en/welcome");

  const options = page.getByRole("radio");
  await expect(options).toHaveCount(6);

  for (const stage of [
    /teenager/i,
    /tracking my cycle/i,
    /trying to conceive/i,
    /pregnant/i,
    /recently gave birth/i,
    /menopause/i,
  ]) {
    await expect(page.getByRole("radio", { name: stage })).toBeVisible();
  }

  await expect(options.first()).not.toBeChecked();
  await options.first().click();
  await expect(options.first()).toBeChecked();
});
