import { expect, test } from "@playwright/test";

// Passwordless sign-in page (P1.12.1). DB-free: rendering + the error state + the
// create-account link need no backend (the magic-link send is only on submit).
test("sign-in page renders the email form and links to onboarding", async ({ page }) => {
  await page.goto("/en/sign-in");
  await expect(page.getByRole("heading", { name: /^sign in$/i })).toBeVisible();
  await expect(page.getByLabel(/email/i)).toBeVisible();
  await expect(page.getByRole("button", { name: /email me a link/i })).toBeVisible();
  await page.getByRole("link", { name: /create an account/i }).click();
  await expect(page).toHaveURL(/\/en\/welcome$/);
});

test("sign-in shows an error when the magic link failed", async ({ page }) => {
  await page.goto("/en/sign-in?error=1");
  await expect(page.getByText(/didn.t work or expired/i)).toBeVisible();
});

test("home links to sign-in", async ({ page }) => {
  await page.goto("/en");
  await page.getByRole("link", { name: /^sign in$/i }).click();
  await expect(page).toHaveURL(/\/en\/sign-in$/);
});
