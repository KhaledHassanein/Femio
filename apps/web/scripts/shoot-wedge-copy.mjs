#!/usr/bin/env node
/**
 * Photographs the wedge-copy pages at 390x844, light and dark (R2.2, R2.5): the home
 * page and the Learn hub in English and Arabic, and the Arabic due-date calculator
 * after jumping to a month with the month strip and tapping a day. The screenshot is
 * the test (CLAUDE.md).
 *
 * Usage (from apps/web): node scripts/shoot-wedge-copy.mjs [--base http://localhost:3000] [--out DIR]
 * Needs a running built site (`pnpm --filter web start`). Writes PNGs only.
 */
import { chromium } from "@playwright/test";
import { mkdirSync } from "node:fs";
import { join } from "node:path";

const args = Object.fromEntries(process.argv.slice(2).map((a, i, all) => (a.startsWith("--") ? [a.slice(2), all[i + 1]] : [])).filter(Boolean));
const base = args.base ?? "http://localhost:3000";
const out = args.out ?? join("..", "..", "testing-results", "2026-10-28-wedge-copy");
mkdirSync(out, { recursive: true });

const iso = (daysAgo) => {
  const d = new Date();
  d.setDate(d.getDate() - daysAgo);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
};

const PAGES = [
  { name: "home-en", path: "/en" },
  { name: "home-ar", path: "/ar" },
  { name: "learn-en", path: "/en/learn" },
  { name: "learn-ar", path: "/ar/learn" },
  { name: "app-ar", path: "/ar/app" },
  { name: "due-date-ar-fresh", path: "/ar/calculators/due-date" },
  { name: "due-date-en-fresh", path: "/en/calculators/due-date" },
  { name: "due-date-ar-tapped", path: "/ar/calculators/due-date", tapDaysAgo: 70 },
];

const browser = await chromium.launch();
for (const scheme of ["light", "dark"]) {
  for (const p of PAGES) {
    const locale = p.path.split("/")[1];
    const context = await browser.newContext({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 2, colorScheme: scheme, locale });
    const page = await context.newPage();
    await page.goto(`${base}${p.path}`, { waitUntil: "networkidle" });
    if (p.tapDaysAgo) {
      const day = iso(p.tapDaysAgo);
      const now = new Date();
      const monthsBack = now.getFullYear() * 12 + now.getMonth() - (Number(day.slice(0, 4)) * 12 + Number(day.slice(5, 7)) - 1);
      const chips = page.locator("nav[aria-label] ul li button");
      const count = await chips.count();
      await chips.nth(count - 1 - monthsBack).click();
      await page.locator(`button[data-iso="${day}"]`).first().click();
    }
    await page.waitForTimeout(500);
    const file = join(out, `${p.name}-${scheme}.png`);
    // The calculator shots are the top of the page (strip + grid + result); the others are full pages.
    await page.screenshot({ path: file, fullPage: !p.name.startsWith("due-date") });
    console.log("wrote", file);
    await context.close();
  }
}
await browser.close();
