import { expect, test } from "@playwright/test";

// Sign-in (P1.12.1): password by default, magic link + (flagged) Google as
// alternatives. DB-free — rendering/toggle/links need no backend.
test("sign-in shows the password form and links to onboarding", async ({ page }) => {
  await page.goto("/en/sign-in");
  await expect(page.getByRole("heading", { name: /^sign in$/i })).toBeVisible();
  await expect(page.getByLabel(/^email$/i)).toBeVisible();
  await expect(page.getByLabel(/^password$/i)).toBeVisible();
  await expect(page.getByRole("button", { name: /forgot password/i })).toBeVisible();
  await page.getByRole("link", { name: /create an account/i }).click();
  await expect(page).toHaveURL(/\/en\/welcome$/);
});

test("can switch to the magic-link method", async ({ page }) => {
  await page.goto("/en/sign-in");
  await page.getByRole("button", { name: /email link instead/i }).click();
  await expect(page.getByRole("button", { name: /email me a link/i })).toBeVisible();
  await expect(page.getByLabel(/^password$/i)).toHaveCount(0);
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

test("reset-password page shows the expired state without a recovery session", async ({ page }) => {
  await page.goto("/en/reset-password");
  // No recovery session → invalid/expired link message + a way back.
  await expect(page.getByRole("link", { name: /back to sign in/i })).toBeVisible();
});
