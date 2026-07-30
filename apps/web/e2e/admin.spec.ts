import { expect, test } from "@playwright/test";

// @live — the translation portal is staff-only: a non-staff visitor is redirected
// home by requireStaff (RLS is the real boundary; this proves the route guard).
test("translations portal redirects non-staff away @live", async ({ page }) => {
  await page.goto("/en/admin/translations");
  await expect(page).toHaveURL(/\/en$/);
  await expect(page.getByRole("heading", { name: /translations/i })).toHaveCount(0);
});

// @live — the insights dashboard is admin-only. Its numbers are aggregates over
// health-adjacent data (P1.20.3), so the route guard failing open would be worse
// than for the translation portal; the RPCs refuse non-staff independently
// (proven by `pnpm rls-audit`), and this pins the UI guard.
test("insights dashboard redirects non-staff away @live", async ({ page }) => {
  await page.goto("/en/admin/insights");
  await expect(page).toHaveURL(/\/en$/);
  await expect(page.getByRole("heading", { name: /product insights/i })).toHaveCount(0);
});
