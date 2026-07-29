import { expect, test } from "@playwright/test";

// Content hub (P1.6.2). DB-free: with no CMS URL configured the client returns
// nothing, so the page renders its graceful empty state (no network needed).
test("learn hub renders (empty state when no CMS content)", async ({ page }) => {
  await page.goto("/en/learn");
  await expect(page.getByRole("heading", { name: /^learn$/i })).toBeVisible();
  // Either published articles or the graceful empty message.
  await expect(page.getByText(/new guides are on the way|medically-reviewed guides/i).first()).toBeVisible();
});

test("home links to the learn hub", async ({ page }) => {
  await page.goto("/en");
  await page.getByRole("link", { name: /^learn$/i }).click();
  await expect(page).toHaveURL(/\/en\/learn$/);
});
