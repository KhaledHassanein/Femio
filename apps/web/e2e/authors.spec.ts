import { expect, test } from "@playwright/test";

// Author/reviewer bios (P1.9b.3b). Content is built in from the repo snapshot (D3),
// so the published reviewer is listed with no network, and an unknown slug 404s.
test("authors index lists the published reviewer", async ({ page }) => {
  await page.goto("/en/authors");
  await expect(page.getByRole("heading", { name: /authors & reviewers/i })).toBeVisible();
  await expect(page.getByRole("main").getByRole("link", { name: /dr\. khaled/i }).first()).toBeVisible();
  // Links out to the trust pages that explain the review standard (E-E-A-T).
  await expect(page.getByRole("main").getByRole("link", { name: /editorial policy/i })).toBeVisible();
});

test("authors index is reachable from the footer", async ({ page }) => {
  await page.goto("/en");
  await page.getByRole("contentinfo").getByRole("link", { name: /authors & reviewers/i }).click();
  await expect(page).toHaveURL(/\/en\/authors$/);
});

test("an unknown author slug returns 404", async ({ page }) => {
  const res = await page.goto("/en/authors/nobody-here");
  expect(res?.status()).toBe(404);
});

test("authors index renders in Arabic (RTL)", async ({ page }) => {
  await page.goto("/ar/authors");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.getByRole("heading", { name: /الكاتبات والمراجعون/ })).toBeVisible();
});

test("the authors index is in the sitemap", async ({ page }) => {
  const xml = await (await page.request.get("/sitemap.xml")).text();
  expect(xml).toContain("/en/authors");
  expect(xml).toContain("/ar/authors");
});
