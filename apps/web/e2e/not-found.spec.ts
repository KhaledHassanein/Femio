import { expect, test } from "@playwright/test";

// Unknown content URLs must 404, not 500 (P1.2.2).
//
// This is a regression net for a bug that was live for weeks: `notFound()` in a
// statically-rendered route made next-intl resolve the locale from `headers()`
// during the not-found pass — a dynamic API, illegal there — so every stale or
// mistyped slug under /learn, /conditions and /authors returned a 500. It was
// invisible locally because `next dev` renders everything dynamically; only the
// production build (what CI runs, and what users get) failed.
const CONTENT_ROUTES = ["/en/learn/no-such-article", "/en/conditions/no-such-topic", "/en/authors/nobody"];

for (const path of CONTENT_ROUTES) {
  test(`${path} returns 404, not a server error`, async ({ page }) => {
    const res = await page.goto(path);
    expect(res?.status()).toBe(404);
    await expect(page.getByRole("heading", { level: 1 })).toBeVisible();
  });
}

test("the 404 page is localized and offers a way back", async ({ page }) => {
  await page.goto("/en/learn/no-such-article");
  await expect(page.getByRole("heading", { name: /couldn.t find that page/i })).toBeVisible();
  await page.getByRole("link", { name: /browse the library/i }).click();
  await expect(page).toHaveURL(/\/en\/learn$/);
});

test("an unknown path outside the content routes also 404s", async ({ page }) => {
  const res = await page.goto("/en/nothing-here");
  expect(res?.status()).toBe(404);
});

test("the 404 page renders right-to-left in Arabic", async ({ page }) => {
  const res = await page.goto("/ar/authors/nobody");
  expect(res?.status()).toBe(404);
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.getByRole("heading", { name: /تعذّر العثور على هذه الصفحة/ })).toBeVisible();
});

// A path no route matches got Next's bare built-in 404 (no lang, no way back) until
// the [locale]/[...rest] catch-all (public audit 2026-10-09).
test("an unmatched path gets the localized 404, with lang set", async ({ page }) => {
  const res = await page.goto("/ar/no-such-section/at-all");
  expect(res?.status()).toBe(404);
  await expect(page.locator("html")).toHaveAttribute("lang", "ar");
  await expect(page.getByRole("heading", { level: 1 })).toBeVisible();
});
