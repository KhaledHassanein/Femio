import { expect, test } from "@playwright/test";

// @live — the translation portal is staff-only: a non-staff visitor is redirected
// home by requireStaff (RLS is the real boundary; this proves the route guard).
test("translations portal redirects non-staff away @live", async ({ page }) => {
  await page.goto("/en/admin/translations");
  await expect(page).toHaveURL(/\/en$/);
  await expect(page.getByRole("heading", { name: /translations/i })).toHaveCount(0);
});
