import { expect, test } from "@playwright/test";
import { completeOnboarding } from "./helpers/onboarding";

// @live — per-symptom severity + a user-defined custom symptom (P1.14.1), against
// live Supabase (throwaway anonymous user).
test("logs a built-in symptom with severity and a custom symptom @live", async ({ page }) => {
  await completeOnboarding(page);
  await page.getByRole("link", { name: /^track$/i }).click();
  await expect(page).toHaveURL(/\/en\/track$/);

  // Select a built-in symptom → it appears in the Selected list with severity chips.
  await page.getByRole("button", { name: /^cramps$/i }).click();
  const cramps = page.getByRole("group", { name: /cramps — intensity/i });
  await expect(cramps).toBeVisible();
  await cramps.getByRole("button", { name: /^moderate$/i }).click();
  await expect(cramps.getByRole("button", { name: /^moderate$/i })).toHaveAttribute("aria-pressed", "true");

  // Add a custom symptom.
  await page.getByPlaceholder(/type a symptom/i).fill("night sweats");
  await page.getByRole("button", { name: /^add$/i }).click();

  await page.getByRole("button", { name: /^log symptoms$/i }).click();

  // Both show under "Recently logged".
  //
  // Scoped to the exact text node rather than a substring match: the custom
  // symptom is echoed back as "night sweats" while the picker above still offers
  // a "Night sweats" chip, so an unscoped `getByText` matched two elements and
  // failed strict mode. Asserting the chip would prove nothing — it is rendered
  // whether or not the log was saved.
  await expect(page.getByText(/recently logged/i)).toBeVisible({ timeout: 25_000 });
  await expect(page.getByText("night sweats", { exact: true })).toBeVisible();
});
