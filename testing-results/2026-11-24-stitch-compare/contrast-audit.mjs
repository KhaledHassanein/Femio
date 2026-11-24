// Contrast audit for a Stitch export: for every visible text element, compares its colour with the
// first opaque background behind it and reports WCAG 2.1 AA failures (4.5:1 normal, 3:1 large text).
// Why: the owner asked to adopt only what is accessibility compliant; a script checks all screens.
// Run from apps/web (needs its @playwright/test). Copy next to apps/web/package.json first, because
// ESM resolves packages from the script's own folder:
//   node ./contrast-audit.mjs <stitch-export-folder> <out.json>
import { chromium } from "@playwright/test";
import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const [src, out] = process.argv.slice(2);
const browser = await chromium.launch();
const page = await (await browser.newContext({ viewport: { width: 390, height: 844 } })).newPage();
const report = {};
for (const dir of fs.readdirSync(src).filter((d) => fs.statSync(path.join(src, d)).isDirectory()).sort()) {
  await page.goto(pathToFileURL(path.join(src, dir, "code.html")).href, { waitUntil: "networkidle" });
  await page.waitForTimeout(500);
  report[dir] = await page.evaluate(() => {
    const parse = (c) => {
      const m = c.match(/rgba?\(([^)]+)\)/);
      if (!m) return null;
      const [r, g, b, a = 1] = m[1].split(/[ ,/]+/).filter(Boolean).map(Number);
      return { r, g, b, a };
    };
    const lum = ({ r, g, b }) => {
      const f = (v) => ((v /= 255) <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4);
      return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
    };
    const bgOf = (el) => {
      for (let e = el; e; e = e.parentElement) {
        const c = parse(getComputedStyle(e).backgroundColor);
        if (c && c.a > 0.9) return c;
      }
      return { r: 255, g: 255, b: 255, a: 1 };
    };
    const fails = [];
    for (const el of document.querySelectorAll("body *")) {
      const own = [...el.childNodes].some((n) => n.nodeType === 3 && n.textContent.trim());
      if (!own) continue;
      const s = getComputedStyle(el);
      const rect = el.getBoundingClientRect();
      if (s.visibility === "hidden" || s.display === "none" || rect.width === 0) continue;
      const fg = parse(s.color);
      if (!fg) continue;
      const bg = bgOf(el);
      // Blend a translucent text colour over its background.
      const mix = { r: fg.r * fg.a + bg.r * (1 - fg.a), g: fg.g * fg.a + bg.g * (1 - fg.a), b: fg.b * fg.a + bg.b * (1 - fg.a) };
      const [L1, L2] = [lum(mix), lum(bg)].sort((a, b) => b - a);
      const ratio = (L1 + 0.05) / (L2 + 0.05);
      const px = parseFloat(s.fontSize);
      const large = px >= 24 || (px >= 18.66 && Number(s.fontWeight) >= 700);
      const need = large ? 3 : 4.5;
      if (ratio < need) fails.push({ text: el.textContent.trim().slice(0, 40), ratio: +ratio.toFixed(2), need, px });
    }
    return fails;
  });
}
fs.writeFileSync(out, JSON.stringify(report, null, 1));
await browser.close();
