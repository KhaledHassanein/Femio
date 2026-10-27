#!/usr/bin/env node
/**
 * Photographs the seven calculators at 390×844, light and dark, in the locales
 * given, after tapping a plausible date, so a change can be judged the way
 * CLAUDE.md asks ("the screenshot is the test").
 *
 * Usage (from apps/web): node scripts/shoot-calculators.mjs [--base http://localhost:3000] [--out DIR] [--locales en,ar]
 * Needs a running site (built: `pnpm --filter web start`). Writes PNGs only.
 */
import { chromium } from "@playwright/test";
import { mkdirSync } from "node:fs";
import { join } from "node:path";

const args = Object.fromEntries(process.argv.slice(2).map((a, i, all) => (a.startsWith("--") ? [a.slice(2), all[i + 1]] : [])).filter(Boolean));
const base = args.base ?? "http://localhost:3000";
const out = args.out ?? join("..", "..", "testing-results", `${new Date().toISOString().slice(0, 10)}-calendar-calculators`);
const locales = (args.locales ?? "en,ar").split(",");
mkdirSync(out, { recursive: true });

const iso = (daysAgo) => {
  const d = new Date();
  d.setDate(d.getDate() - daysAgo);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
};

/** Each calculator: the route and the taps that produce a result. */
const CALCULATORS = [
  { slug: "fertile-window", taps: [iso(10)] },
  { slug: "period", taps: [iso(10)] },
  { slug: "pregnancy-test", taps: [iso(24)] },
  { slug: "due-date", taps: [iso(70)] },
  { slug: "gestational-age", taps: [iso(100)] },
  { slug: "cycle-length", taps: [iso(60), iso(31), iso(2)] },
  { slug: "bmi", taps: [] },
];

const browser = await chromium.launch();
for (const locale of locales) {
  for (const scheme of ["light", "dark"]) {
    const context = await browser.newContext({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 2, colorScheme: scheme, locale });
    const page = await context.newPage();
    for (const calc of CALCULATORS) {
      await page.goto(`${base}/${locale}/calculators/${calc.slug}`, { waitUntil: "networkidle" });
      // The first month shown is the current one; walk to each tap's month the way
      // a thumb would, with the previous/next buttons, tracking where the view is.
      const now = new Date();
      let viewMonths = now.getFullYear() * 12 + now.getMonth();
      for (const day of calc.taps) {
        const target = Number(day.slice(0, 4)) * 12 + Number(day.slice(5, 7)) - 1;
        while (viewMonths !== target) {
          const buttons = page.locator("section header button");
          await (target < viewMonths ? buttons.first() : buttons.nth(1)).click();
          viewMonths += target < viewMonths ? -1 : 1;
        }
        const cell = page.locator(`button[data-iso="${day}"]`).first();
        if (await cell.count()) await cell.click();
        // A tap on a start re-anchors the view on that month.
        viewMonths = target;
      }
      await page.waitForTimeout(600);
      const file = join(out, `${calc.slug}-${locale}-${scheme}.png`);
      await page.screenshot({ path: file, fullPage: true });
      console.log("wrote", file);
    }
    await context.close();
  }
}
await browser.close();
