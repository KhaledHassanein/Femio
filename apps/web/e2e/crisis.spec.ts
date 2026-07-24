import { expect, test, type Page } from "@playwright/test";

// Global crisis-safety routing (docs/compliance/CRISIS_RESOURCES.md, ADR-013).
// These run unauthenticated — the crisis interface must never require an account,
// a questionnaire, or any health data.

const LOCALES = ["en", "ar", "fr", "es"] as const;
const LAUNCHER = /need help now\?/i;
// A distinctive fragment of the approved, verbatim urgent-route sentence.
const URGENT_COPY = /nearest emergency department/i;

async function openDialog(page: Page) {
  await page.getByRole("button", { name: LAUNCHER }).click();
  const dialog = page.getByRole("dialog");
  await expect(dialog).toBeVisible();
  return dialog;
}

for (const locale of LOCALES) {
  test(`[${locale}] launcher is reachable unauthed and opens the crisis dialog`, async ({ page }) => {
    await page.goto(`/${locale}`);
    await expect(page.getByRole("button", { name: LAUNCHER })).toBeVisible();
    const dialog = await openDialog(page);
    await expect(dialog.getByText(URGENT_COPY)).toBeVisible();
  });
}

test("dialog is keyboard-accessible: focus moves inside, Escape closes", async ({ page }) => {
  await page.goto("/en");
  await openDialog(page);

  // Focus is trapped inside the modal <dialog> (native showModal behaviour).
  const focusedInside = await page.evaluate(() => {
    const d = document.querySelector("dialog[open]");
    return !!d && !!document.activeElement && d.contains(document.activeElement);
  });
  expect(focusedInside).toBe(true);

  await page.keyboard.press("Escape");
  await expect(page.locator("dialog[open]")).toHaveCount(0);
});

test("close button dismisses the dialog", async ({ page }) => {
  await page.goto("/en");
  const dialog = await openDialog(page);
  await dialog.getByRole("button", { name: /close/i }).click();
  await expect(page.locator("dialog[open]")).toHaveCount(0);
});

test("[ar] page is RTL but the unreviewed crisis copy falls back to English (lang=en, dir=ltr)", async ({
  page,
}) => {
  await page.goto("/ar");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.locator("html")).toHaveAttribute("lang", "ar");

  const dialog = await openDialog(page);
  // Pending locale → English fallback, explicitly tagged so screen readers switch.
  const fallback = dialog.locator('[lang="en"][dir="ltr"]');
  await expect(fallback.first()).toBeVisible();
  await expect(dialog.getByText(URGENT_COPY)).toBeVisible();
});

test("the crisis dialog opens offline with its bundled fallback copy", async ({ page, context }) => {
  await page.goto("/en");
  await expect(page.getByRole("button", { name: LAUNCHER })).toBeVisible();

  await context.setOffline(true);
  const dialog = await openDialog(page);
  await expect(dialog.getByText(URGENT_COPY)).toBeVisible();
  await context.setOffline(false);
});

test("no unvetted external link is present; emergency fallback still works when the directory is unset", async ({
  page,
}) => {
  await page.goto("/en");
  const dialog = await openDialog(page);

  // With NEXT_PUBLIC_CRISIS_DIRECTORY_URL unset (dev/CI default) the directory
  // action is hidden — but the urgent emergency-services route must still show.
  await expect(dialog.getByText(URGENT_COPY)).toBeVisible();

  // Any link that *is* rendered must point only at the canonical directory host
  // and must not leak a referrer.
  const anchors = dialog.locator("a[href]");
  const count = await anchors.count();
  for (let i = 0; i < count; i++) {
    const href = await anchors.nth(i).getAttribute("href");
    expect(href).toMatch(/^https:\/\/findahelpline\.com\//);
    await expect(anchors.nth(i)).toHaveAttribute("referrerpolicy", "no-referrer");
  }
});

test("the public /help-now page renders the urgent route and is noindex", async ({ page }) => {
  await page.goto("/en/help-now");
  await expect(page.getByRole("main").getByText(URGENT_COPY)).toBeVisible();
  const robots = await page.evaluate(
    () => document.querySelector('meta[name="robots"]')?.getAttribute("content") ?? "",
  );
  expect(robots).toMatch(/noindex/);
});
