import { expect, test } from "@playwright/test";

// Search (D4, P2.2). The library index is a static file built from the content
// snapshot, so this runs with no database: a search makes no Supabase request.
test("search finds a condition and its articles, with no database request", async ({ page }) => {
  const supabase: string[] = [];
  page.on("request", (r) => {
    if (r.url().includes("supabase.co")) supabase.push(r.url());
  });

  await page.goto("/en/search?q=pcos");
  await expect(page.getByRole("heading", { name: /^conditions \(\d+\)$/i })).toBeVisible();
  await expect(page.getByRole("heading", { name: /^articles \(\d+\)$/i })).toBeVisible();
  await expect(page.getByText(/could not run/i)).toHaveCount(0);

  // Typing a question rather than a name still answers it.
  await page.getByLabel(/search femio/i).fill("bleeding after birth");
  await expect(page.getByRole("link", { name: /bleeding/i }).first()).toBeVisible();

  expect(supabase.filter((u) => u.includes("search_content"))).toEqual([]);
});

test("a locale with no translations says the results are the English library; Arabic no longer does", async ({ page }) => {
  // Arabic has its first translated guides (2026-10-28); French still has none.
  await page.goto("/fr/search?q=pcos");
  await expect(page.getByText(/bibliothèque anglaise|en anglais/i)).toBeVisible();
  await page.goto("/ar/search?q=pcos");
  await expect(page.getByText(/المكتبة الإنجليزية/)).toHaveCount(0);
});
