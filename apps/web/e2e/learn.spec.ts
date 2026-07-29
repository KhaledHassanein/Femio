import { expect, test } from "@playwright/test";

// Content hub (P1.6.2). DB-free: with no CMS URL configured the client returns
// nothing, so the page renders its graceful empty state (no network needed).
test("learn hub renders (empty state when no CMS content)", async ({ page }) => {
  await page.goto("/en/learn");
  await expect(page.getByRole("heading", { name: /^learn$/i })).toBeVisible();
  // Either published articles or the graceful empty message.
  await expect(page.getByText(/new guides are on the way|medically-reviewed guides/i).first()).toBeVisible();
});

test("home surfaces the library and links to the learn hub", async ({ page }) => {
  await page.goto("/en");
  // Content-first homepage: section cards into the library.
  await expect(page.getByRole("heading", { name: /whole health life/i })).toBeVisible();
  await page.getByRole("link", { name: /^learn/i }).first().click();
  await expect(page).toHaveURL(/\/en\/learn$/);
});

test("conditions hub renders (empty state when no CMS content)", async ({ page }) => {
  await page.goto("/en/conditions");
  await expect(page.getByRole("heading", { name: /conditions & topics/i })).toBeVisible();
  await expect(page.getByText(/new topics are on the way|guides to conditions/i).first()).toBeVisible();
});

test("faq and glossary pages render", async ({ page }) => {
  await page.goto("/en/faq");
  await expect(page.getByRole("heading", { name: /frequently asked questions/i })).toBeVisible();
  await page.goto("/en/glossary");
  await expect(page.getByRole("heading", { name: /^glossary$/i })).toBeVisible();
});

test("persistent header nav lets you move between content pages", async ({ page }) => {
  await page.goto("/en/learn");
  await page.getByRole("banner").getByRole("link", { name: /^conditions$/i }).click();
  await expect(page).toHaveURL(/\/en\/conditions$/);
  // Footer is present on content pages too.
  await expect(page.getByRole("contentinfo")).toBeVisible();
});
