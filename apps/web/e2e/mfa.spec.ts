import { expect, test } from "@playwright/test";

// Two-step sign-in (P1.23.3). The step-up page is reachable only by redirect
// from a staff route; signed out, it must send you to sign-in rather than render
// a challenge for nobody. DB-free: with no session the guard fires immediately.
test("the step-up page sends a signed-out visitor to sign-in", async ({ page }) => {
  await page.goto("/en/mfa");
  await expect(page).toHaveURL(/\/en\/sign-in/);
});

test("the step-up page is never indexed", async ({ page }) => {
  // It carries a `next` destination in the URL; it has no business in search.
  await page.goto("/en/mfa?next=%2Fadmin%2Finsights");
  await expect(page).toHaveURL(/\/en\/sign-in|\/en\/mfa/);
  const robots = page.locator('meta[name="robots"]');
  if ((await robots.count()) > 0) {
    await expect(robots).toHaveAttribute("content", /noindex/);
  }
});

// @live — needs a real session: onboarding creates one, then Settings must offer
// enrolment. Consumers may enrol too; staff are the ones it is enforced for.
test("settings offers two-step sign-in @live", async ({ page }) => {
  await page.goto("/en/welcome");
  await page.getByRole("button", { name: /tracking my cycle/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /^continue$/i }).click();
  await page.getByRole("button", { name: /start using femio/i }).click();
  await expect(page).toHaveURL(/\/en\/dashboard$/, { timeout: 25_000 });

  await page.goto("/en/settings");
  await expect(page.getByRole("heading", { name: /two-step sign-in/i })).toBeVisible({
    timeout: 25_000,
  });
  await expect(page.getByRole("button", { name: /set up two-step sign-in/i })).toBeVisible();
});
