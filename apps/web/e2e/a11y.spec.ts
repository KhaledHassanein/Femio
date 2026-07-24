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
  "/en/help-now",
  "/en/welcome",
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
