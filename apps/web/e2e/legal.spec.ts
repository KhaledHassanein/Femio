import { expect, test } from "@playwright/test";

// Privacy + Terms drafts (P1.9b.3). These pages must (a) render, (b) say plainly
// that they are drafts pending counsel, and (c) stay out of the index until P0.12
// finalizes the binding text. DB-free, so they run in CI.
test("privacy page renders, is marked a draft, and is noindex", async ({ page }) => {
  await page.goto("/en/privacy");
  await expect(page.getByRole("heading", { name: /privacy policy/i })).toBeVisible();
  // Scope to the page: production also renders Next's route announcer, which
  // carries role="alert" and would make a bare getByRole("alert") ambiguous.
  await expect(page.getByRole("main").getByRole("alert")).toContainText(/draft — not yet in force/i);
  await expect(page.locator('meta[name="robots"]')).toHaveAttribute("content", /noindex/);
});

test("terms page renders, is marked a draft, and is noindex", async ({ page }) => {
  await page.goto("/en/terms");
  await expect(page.getByRole("heading", { name: /terms of use/i })).toBeVisible();
  // Scope to the page: production also renders Next's route announcer, which
  // carries role="alert" and would make a bare getByRole("alert") ambiguous.
  await expect(page.getByRole("main").getByRole("alert")).toContainText(/draft — not yet in force/i);
  await expect(page.locator('meta[name="robots"]')).toHaveAttribute("content", /noindex/);
  // The wellness boundary must be stated on the terms page itself.
  await expect(page.getByText(/not a reliable way to avoid pregnancy/i)).toBeVisible();
});

test("privacy and terms are reachable from the footer and cross-linked", async ({ page }) => {
  await page.goto("/en");
  await page.getByRole("contentinfo").getByRole("link", { name: /^privacy$/i }).click();
  await expect(page).toHaveURL(/\/en\/privacy$/);
  await page.getByRole("main").getByRole("link", { name: /^terms$/i }).click();
  await expect(page).toHaveURL(/\/en\/terms$/);
});

test("the privacy draft renders in Arabic (RTL)", async ({ page }) => {
  await page.goto("/ar/privacy");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.getByRole("heading", { name: /سياسة الخصوصية/ })).toBeVisible();
});

test("neither draft is listed in the sitemap", async ({ page }) => {
  const res = await page.request.get("/sitemap.xml");
  const xml = await res.text();
  expect(xml).not.toContain("/privacy");
  expect(xml).not.toContain("/terms");
  expect(xml).toContain("/en/about");
});
