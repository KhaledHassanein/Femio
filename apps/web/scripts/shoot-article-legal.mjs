#!/usr/bin/env node
/**
 * Photographs the article template, the privacy policy and help-now at 390x844,
 * light and dark, English and Arabic (R2.3 and R2.4), so the change can be judged the
 * way CLAUDE.md asks ("the screenshot is the test").
 *
 * Usage (from apps/web): node scripts/shoot-article-legal.mjs [--base http://localhost:3000] [--out DIR]
 * Needs a running built site (`pnpm --filter web start`). Writes PNGs only.
 */
import { chromium } from "@playwright/test";
import { mkdirSync } from "node:fs";
import { join } from "node:path";

const args = Object.fromEntries(
  process.argv
    .slice(2)
    .map((a, i, all) => (a.startsWith("--") ? [a.slice(2), all[i + 1]] : []))
    .filter((p) => p.length),
);
const base = args.base ?? "http://localhost:3000";
const out = args.out ?? join("..", "..", "testing-results", `${new Date().toISOString().slice(0, 10)}-article-legal`);
mkdirSync(out, { recursive: true });

/** A reviewed wedge article, an unreviewed one, the policy, and help-now with a country picked. */
const SHOTS = [
  { name: "article-reviewed", path: (l) => `/${l}/learn/when-to-seek-fertility-help` },
  { name: "article-pending", path: (l) => `/${l}/learn/age-and-fertility` },
  { name: "privacy", path: (l) => `/${l}/privacy` },
  { name: "terms", path: (l) => `/${l}/terms` },
  {
    name: "help-now",
    path: (l) => `/${l}/help-now`,
    act: async (page, l) => {
      await page.getByRole("button", { name: l === "ar" ? "مصر" : "Egypt" }).click();
    },
  },
];

const browser = await chromium.launch();
for (const locale of ["en", "ar"]) {
  for (const scheme of ["light", "dark"]) {
    const context = await browser.newContext({
      viewport: { width: 390, height: 844 },
      deviceScaleFactor: 2,
      colorScheme: scheme,
      locale,
    });
    const page = await context.newPage();
    for (const shot of SHOTS) {
      await page.goto(`${base}${shot.path(locale)}`, { waitUntil: "networkidle" });
      if (shot.act) await shot.act(page, locale);
      await page.waitForTimeout(400);
      const file = join(out, `${shot.name}-${locale}-${scheme}.png`);
      await page.screenshot({ path: file, fullPage: true });
      console.log("wrote", file);
      // The fold, and the first red-flag box, are what the eye judges; the full page is too tall to read.
      await page.screenshot({ path: file.replace(".png", "-fold.png") });
      const box = page.getByTestId("red-flag-box").first();
      if (await box.count()) {
        await box.scrollIntoViewIfNeeded();
        await box.screenshot({ path: file.replace(".png", "-redflag.png") });
      }
    }
    await context.close();
  }
}
await browser.close();
