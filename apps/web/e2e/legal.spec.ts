import { expect, test } from "@playwright/test";

// Privacy policy + terms of use (R2.4, text from docs/33_REBUILD_V3/03_LEGAL_PACK.md).
// The pages are real and indexable. The owner's blanks ([ENTITY], [EMAIL], [DATE]) render
// highlighted so none can be published by accident. DB-free, so they run in CI.
test("privacy page renders the policy, shows the effective-date placeholder, and is indexable", async ({ page }) => {
  await page.goto("/en/privacy");
  await expect(page.getByRole("heading", { level: 1, name: /privacy policy/i })).toBeVisible();
  await expect(page.getByRole("main").getByText(/effective date:/i)).toContainText("[DATE]");
  // The "in short" box carries the promise the rest of the page has to keep.
  await expect(page.getByRole("heading", { name: /the short version/i })).toBeVisible();
  await expect(page.getByRole("main").getByText(/on your phone only/i).first()).toBeVisible();
  // Placeholders are visible, highlighted, never silently dropped.
  await expect(page.locator("main mark", { hasText: "[EMAIL]" }).first()).toBeVisible();
  await expect(page.locator("main mark", { hasText: "[ENTITY]" }).first()).toBeVisible();
  // The old draft banner is gone, and so is the noindex.
  await expect(page.getByText(/draft — not yet in force/i)).toHaveCount(0);
  const robots = await page.locator('meta[name="robots"]').getAttribute("content");
  expect(robots ?? "").not.toMatch(/noindex/);
});

test("terms page renders the terms and states the wellness boundary", async ({ page }) => {
  await page.goto("/en/terms");
  await expect(page.getByRole("heading", { level: 1, name: /terms of use/i })).toBeVisible();
  await expect(page.getByRole("main").getByText(/effective date:/i)).toContainText("[DATE]");
  // The wellness boundary must be stated on the terms page itself.
  await expect(page.getByText(/must not be relied on to avoid one/i)).toBeVisible();
  await expect(page.getByRole("heading", { name: /not a way to avoid pregnancy/i })).toBeVisible();
  const robots = await page.locator('meta[name="robots"]').getAttribute("content");
  expect(robots ?? "").not.toMatch(/noindex/);
});

test("the contents list jumps to a section", async ({ page }) => {
  await page.goto("/en/terms");
  await page.getByRole("navigation", { name: /on this page/i }).getByRole("link", { name: /^limits$/i }).click();
  await expect(page).toHaveURL(/#section-10$/);
});

test("privacy and terms are reachable from the footer and cross-linked", async ({ page }) => {
  await page.goto("/en");
  await page.getByRole("contentinfo").getByRole("link", { name: /^privacy$/i }).click();
  await expect(page).toHaveURL(/\/en\/privacy$/);
  await page.getByRole("main").getByRole("link", { name: /^terms$/i }).click();
  await expect(page).toHaveURL(/\/en\/terms$/);
});

test("the privacy policy renders in Arabic (RTL), with the Latin wordmark", async ({ page }) => {
  await page.goto("/ar/privacy");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.getByRole("heading", { level: 1, name: /سياسة الخصوصية/ })).toBeVisible();
  await expect(page.getByRole("main").getByText(/تاريخ السريان/)).toContainText("[DATE]");
  await expect(page.getByRole("main").getByText("على هاتفكِ فقط").first()).toBeVisible();
});

test("French and Spanish legal pages render their own language", async ({ page }) => {
  await page.goto("/fr/privacy");
  await expect(page.getByRole("heading", { level: 1, name: /politique de confidentialité/i })).toBeVisible();
  await page.goto("/es/terms");
  await expect(page.getByRole("heading", { level: 1, name: /condiciones de uso/i })).toBeVisible();
});

test("both legal pages are listed in the sitemap", async ({ page }) => {
  const res = await page.request.get("/sitemap.xml");
  const xml = await res.text();
  expect(xml).toContain("/privacy");
  expect(xml).toContain("/terms");
  expect(xml).toContain("/en/about");
});
