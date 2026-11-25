// Renders a Stitch export (one folder per screen, each with code.html) to 390x844 PNGs at 2x,
// plus a full-height shot and the visible text. Run from apps/web (uses its @playwright/test):
//   node ../../testing-results/2026-11-24-stitch-compare/render-stitch.mjs <stitch-export-folder> <output-folder>
import { chromium } from "@playwright/test";
import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";
const src = process.argv[2], out = process.argv[3];
const browser = await chromium.launch();
const ctx = await browser.newContext({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 2 });
const page = await ctx.newPage();
const texts = {};
for (const dir of fs.readdirSync(src).filter((d) => fs.statSync(path.join(src, d)).isDirectory()).sort()) {
  const file = path.join(src, dir, "code.html");
  await page.goto(pathToFileURL(file).href, { waitUntil: "networkidle" });
  await page.waitForTimeout(800);
  const name = dir.replace(/\._/, "_");
  await page.screenshot({ path: path.join(out, `${name}.png`) });
  // Unclip the phone frame: every scrolling box grows to its content, so a full-page shot shows all.
  const h = await page.evaluate(() => {
    for (const el of document.querySelectorAll("*")) {
      const s = getComputedStyle(el);
      if (/(auto|scroll)/.test(s.overflowY) && el.scrollHeight > el.clientHeight) {
        el.style.overflow = "visible"; el.style.height = "auto"; el.style.maxHeight = "none";
      }
      if (s.position === "fixed" && el.getBoundingClientRect().top > 600) el.style.position = "static";
    }
    document.documentElement.style.height = "auto"; document.body.style.height = "auto";
    return document.documentElement.scrollHeight;
  });
  await page.screenshot({ path: path.join(out, `${name}_full.png`), fullPage: true });
  texts[name] = await page.evaluate(() => document.body.innerText);
  console.log(name, h);
}
fs.writeFileSync(path.join(out, "texts.json"), JSON.stringify(texts, null, 1));
await browser.close();
