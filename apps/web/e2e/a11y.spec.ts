import AxeBuilder from "@axe-core/playwright";
import { expect, test, type Page } from "@playwright/test";

// Automated WCAG 2.1 A/AA accessibility audit (P1.5.2 / P1.22) on the key public
// surfaces, in both an LTR and an RTL locale. DB-free, so it runs in CI. We gate
// on serious + critical violations (the audit floor); moderate/minor are tracked
// as a follow-up rather than silently ignored.
const WCAG = ["wcag2a", "wcag2aa", "wcag21a", "wcag21aa"];

async function auditSerious(page: Page) {
  const results = await new AxeBuilder({ page }).withTags(WCAG).analyze();
  return results.violations
    .filter((v) => v.impact === "serious" || v.impact === "critical")
    .map((v) => ({ id: v.id, impact: v.impact, nodes: v.nodes.length }));
}

const PAGES = [
  "/en",
  "/en/calculators",
  "/en/calculators/due-date",
  "/en/calculators/period",
  "/en/calculators/pregnancy-test",
  "/en/calculators/fertile-window",
  "/ar/calculators/fertile-window",
  "/ar/calculators/due-date",
  "/en/app",
  "/ar/app",
  "/en/help-now",
  "/en/about",
  "/en/editorial-policy",
  "/en/privacy",
  "/en/terms",
  "/en/authors",
  "/ar",
  "/ar/help-now",
];

for (const path of PAGES) {
  test(`a11y: ${path} has no serious/critical violations`, async ({ page }) => {
    await page.goto(path);
    await expect(page.getByRole("heading").first()).toBeVisible();
    const violations = await auditSerious(page);
    expect(violations, JSON.stringify(violations, null, 2)).toEqual([]);
  });
}

test("a11y: the crisis dialog (open state) has no serious/critical violations", async ({ page }) => {
  await page.goto("/en");
  await page.getByRole("button", { name: /need help now\?/i }).click();
  await expect(page.getByRole("dialog")).toBeVisible();
  const violations = await auditSerious(page);
  expect(violations, JSON.stringify(violations, null, 2)).toEqual([]);
});

/**
 * Reduced motion (WCAG 2.3.3, P1.28.6).
 *
 * The global rule in `globals.css` is the backstop for every animation in the app,
 * including ones a component author forgot to wrap in `motion-safe:` and ones that
 * arrive with a dependency. It is also invisible: nothing on screen looks different
 * unless you are the person who asked for it. So it gets an assertion in both
 * directions — a rule that never applies and a rule that always applies both look
 * like "no animation" from the outside, and only one of them is correct.
 *
 * A calculator page carries the hand-off pill, styled by `buttonVariants`, the widest-used
 * transition in the app.
 */
function longestDurationMs(value: string): number {
  return Math.max(
    ...value.split(",").map((part) => {
      const trimmed = part.trim();
      const n = Number.parseFloat(trimmed);
      return Number.isNaN(n) ? 0 : trimmed.endsWith("ms") ? n : n * 1000;
    }),
  );
}

const durationOfContinue = (page: Page) =>
  page
    .getByRole("link", { name: /^get the app$/i })
    .last()
    .evaluate((el) => getComputedStyle(el).transitionDuration);

test("a11y: reduced motion is honoured, and motion exists when it is not asked for", async ({
  page,
}) => {
  // The hand-off card's pill (styled by `buttonVariants`) is the last "Get the app"
  // link on a calculator page; the header's plain link comes first.
  await page.goto("/en/calculators/period");

  await page.emulateMedia({ reducedMotion: "no-preference" });
  expect(longestDurationMs(await durationOfContinue(page))).toBeGreaterThanOrEqual(100);

  await page.emulateMedia({ reducedMotion: "reduce" });
  expect(longestDurationMs(await durationOfContinue(page))).toBeLessThan(1);
});
