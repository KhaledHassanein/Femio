import { expect, test, type Page } from "@playwright/test";

// Keyboard pass on the calendar calculators (R2.7, WAI-ARIA grid pattern). A reader who
// cannot use a pointer must be able to reach the grid with Tab, move between days with
// the arrow keys (visual direction, so ArrowLeft is "next day" in Arabic), pick a day with
// Enter, and have the result announced: the result sentence is a status region.
// A real screen-reader pass (NVDA) is a separate, owner-run step recorded in testing-results/.

/** Tab from the top of the page until a day button inside the grid has focus. */
async function tabIntoGrid(page: Page) {
  for (let i = 0; i < 40; i += 1) {
    await page.keyboard.press("Tab");
    const inGrid = await page.evaluate(() => {
      const el = document.activeElement as HTMLElement | null;
      return Boolean(el && el.dataset.iso && el.closest('[role="grid"]'));
    });
    if (inGrid) return;
  }
  throw new Error("Tab never reached a day button inside the calendar grid");
}

const focusedIso = (page: Page) => page.evaluate(() => (document.activeElement as HTMLElement | null)?.dataset.iso ?? null);
const nextDay = (iso: string) => {
  const d = new Date(`${iso}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + 1);
  return d.toISOString().slice(0, 10);
};

for (const { locale, next, prev } of [
  { locale: "en", next: "ArrowRight", prev: "ArrowLeft" },
  { locale: "ar", next: "ArrowLeft", prev: "ArrowRight" },
]) {
  test(`${locale}: the fertile-window calendar works from the keyboard alone`, async ({ page }) => {
    await page.goto(`/${locale}/calculators/fertile-window`);
    const grid = page.getByRole("grid").first();
    await expect(grid).toBeVisible();
    // Exactly one day is in the tab order (roving tabindex), and it is today.
    await expect(grid.locator('button[tabindex="0"]')).toHaveCount(1);
    await expect(grid.locator('button[tabindex="0"]')).toHaveAttribute("aria-current", "date");

    await tabIntoGrid(page);
    const start = await focusedIso(page);
    expect(start).not.toBeNull();

    // Arrow keys move by one day in the visual direction; the week row moves by seven.
    await page.keyboard.press(next);
    expect(await focusedIso(page)).toBe(nextDay(start!));
    await page.keyboard.press(prev);
    expect(await focusedIso(page)).toBe(start);
    await page.keyboard.press("ArrowUp");
    const upIso = await focusedIso(page);
    expect(upIso).not.toBe(start);
    expect(Date.parse(start!) - Date.parse(upIso!)).toBe(7 * 86_400_000);

    // Enter picks the focused day: the cell is selected and a result is announced.
    await expect(page.getByRole("status")).toHaveCount(0);
    await page.keyboard.press("Enter");
    await expect(page.locator('[role="gridcell"][aria-selected="true"]')).toHaveCount(1);
    const status = page.getByRole("status");
    await expect(status).toBeVisible();
    await expect(status).not.toHaveText("");

    // Every day button has an accessible name (the full date), never just a number.
    const names = await grid.locator("button[data-iso]").evaluateAll((els) => els.map((e) => e.getAttribute("aria-label") ?? ""));
    expect(names.length).toBeGreaterThan(27);
    for (const name of names) expect(name.length).toBeGreaterThan(4);
  });
}

test("the Arabic calendar starts the week on Saturday and shows Western digits", async ({ page }) => {
  await page.goto("/ar/calculators/fertile-window");
  const grid = page.getByRole("grid").first();
  const headers = await grid.getByRole("columnheader").evaluateAll((els) => els.map((e) => e.getAttribute("aria-label") ?? ""));
  expect(headers[0]).toBe("السبت");
  expect(headers).toHaveLength(7);
  const digits = await grid.locator("button[data-iso]").first().textContent();
  expect(digits).toMatch(/[0-9]/);
  expect(digits).not.toMatch(/[٠-٩]/);
});
