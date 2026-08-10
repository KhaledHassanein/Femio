import { expect, test, type Page } from "@playwright/test";

// Global crisis-safety routing (docs/compliance/CRISIS_RESOURCES.md, ADR-013).
// These run unauthenticated — the crisis interface must never require an account,
// a questionnaire, or any health data.

const LOCALES = ["en", "ar", "fr", "es"] as const;
type Locale = (typeof LOCALES)[number];

/**
 * Per-locale launcher name and a distinctive fragment of the approved, verbatim
 * urgent-route sentence.
 *
 * These were English-only while ar/fr/es rendered the English fallback. All four are
 * approved as of 2026-08-11 (ADR-063), so asserting English here would now pass for
 * the wrong reason in exactly one case — a locale silently reverting to `pending`
 * would go green. The fragment is the *routing* sentence, not a heading: it is the
 * line that has to reach a reader in a crisis.
 */
const COPY: Record<Locale, { launcher: RegExp; urgent: RegExp }> = {
  en: { launcher: /need help now\?/i, urgent: /nearest emergency department/i },
  ar: { launcher: /تحتاجين مساعدة الآن؟/, urgent: /أقرب قسم طوارئ/ },
  fr: { launcher: /besoin d'aide maintenant/i, urgent: /service des urgences le plus proche/i },
  es: { launcher: /necesitas ayuda ahora/i, urgent: /servicio de urgencias más cercano/i },
};

const LAUNCHER = COPY.en.launcher;
const URGENT_COPY = COPY.en.urgent;

async function openDialog(page: Page, locale: Locale = "en") {
  await page.getByRole("button", { name: COPY[locale].launcher }).click();
  const dialog = page.getByRole("dialog");
  await expect(dialog).toBeVisible();
  return dialog;
}

for (const locale of LOCALES) {
  test(`[${locale}] launcher is reachable unauthed and opens the crisis dialog`, async ({ page }) => {
    await page.goto(`/${locale}`);
    await expect(page.getByRole("button", { name: COPY[locale].launcher })).toBeVisible();
    const dialog = await openDialog(page, locale);
    await expect(dialog.getByText(COPY[locale].urgent)).toBeVisible();
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

test("[ar] the crisis dialog renders approved Arabic, RTL, with no English fallback", async ({
  page,
}) => {
  await page.goto("/ar");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.locator("html")).toHaveAttribute("lang", "ar");

  const dialog = await openDialog(page, "ar");

  // Arabic was approved 2026-08-11 (ADR-063), so the English fallback must be GONE.
  // Asserting its absence is the load-bearing half: a locale that silently reverted
  // to `pending` would still pass a "some Arabic is visible" check via the page
  // chrome around the dialog.
  await expect(dialog.locator('[lang="en"][dir="ltr"]')).toHaveCount(0);

  // The substantive routing sentence, not a heading — this is the line that has to
  // reach an Arabic reader in a crisis.
  await expect(
    dialog.getByText("فاتصلي بخدمات الطوارئ المتاحة في المكان الذي أنتِ فيه الآن", {
      exact: false,
    }),
  ).toBeVisible();

  // No phone number may appear in any locale (global-only posture, P1.26.1).
  await expect(dialog.getByText(/\d{3,}/)).toHaveCount(0);
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
