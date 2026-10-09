import { expect, test } from "@playwright/test";

/**
 * Every internal link on a locale's pages stays in that locale.
 *
 * From 2026-08-23 to 2026-10-09 every link on the Arabic site pointed at
 * `/ar-u-nu-latn/...` and 404'd (public audit F01): the request config returned a
 * formatting locale as the route locale. Pages opened by typed URL looked fine, so
 * nothing that loaded a page directly caught it. This reads the hrefs.
 */
for (const locale of ["ar", "en", "fr", "es"] as const) {
  for (const path of ["", "/learn", "/calculators/due-date"]) {
    test(`internal links on /${locale}${path} stay under /${locale}/`, async ({ page }) => {
      await page.goto(`/${locale}${path}`);
      const hrefs = await page
        .locator("a[href^='/']")
        .evaluateAll((as) => as.map((a) => a.getAttribute("href")!));
      expect(hrefs.length).toBeGreaterThan(5);
      // The language switcher is the one deliberate exception: it links the other locales.
      const others = ["en", "ar", "fr", "es"].filter((l) => l !== locale);
      const stray = hrefs.filter(
        (h) =>
          !h.startsWith(`/${locale}`) &&
          !others.some((o) => h === `/${o}` || h.startsWith(`/${o}/`)),
      );
      expect(stray).toEqual([]);
      expect(hrefs.some((h) => h.includes("-u-"))).toBe(false);
    });
  }
}

test("Arabic header link reaches the Arabic library", async ({ page }) => {
  await page.goto("/ar");
  await page.locator("header nav a[href='/ar/learn']").first().click();
  await expect(page).toHaveURL(/\/ar\/learn$/);
  await expect(page.locator("h1").first()).toBeVisible();
});
