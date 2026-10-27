#!/usr/bin/env node
/**
 * Renders the Open Graph share image per locale (1200×630) with a real browser,
 * so Arabic shapes correctly and the self-hosted fonts are the ones on the site
 * (02_DESIGN_SPEC §5). Dusk aurora on plum-900, the Latin wordmark, one line of
 * copy from the locale's `meta.description`. Writes apps/web/public/og/{locale}.png.
 *
 * Usage (from apps/web): node scripts/render-og.mjs
 */
import { chromium } from "@playwright/test";
import { mkdirSync, readFileSync } from "node:fs";
import { join } from "node:path";

const LOCALES = ["en", "ar", "fr", "es"];
const out = join("public", "og");
mkdirSync(out, { recursive: true });

const html = (locale, description) => `<!doctype html>
<html lang="${locale}" dir="${locale === "ar" ? "rtl" : "ltr"}"><head><meta charset="utf-8">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Newsreader:opsz,wght@6..72,600&family=Plus+Jakarta+Sans:wght@500&family=IBM+Plex+Sans+Arabic:wght@500&display=swap" rel="stylesheet">
<style>
  html,body{margin:0;width:1200px;height:630px;overflow:hidden}
  body{position:relative;background:#3F1534;color:#FFF8F1;font-family:"Plus Jakarta Sans","IBM Plex Sans Arabic",system-ui,sans-serif}
  .light{position:absolute;border-radius:50%;filter:blur(90px);opacity:.75}
  .l1{width:620px;height:620px;background:#EE6A8C;left:620px;top:-180px}
  .l2{width:520px;height:520px;background:#F7B394;left:860px;top:200px;opacity:.55}
  .l3{width:420px;height:420px;background:#E5BC6B;left:300px;top:380px;opacity:.38}
  .l4{width:560px;height:560px;background:#C56EA7;left:-160px;top:-120px;opacity:.6}
  .wrap{position:absolute;inset:0;padding:84px 96px;display:flex;flex-direction:column;justify-content:space-between}
  .mark{font-family:Newsreader,Georgia,serif;font-size:132px;line-height:1;letter-spacing:-.03em;direction:ltr}
  .copy{font-size:40px;line-height:1.35;max-width:980px;font-weight:500}
  .tag{font-size:26px;opacity:.85;letter-spacing:.08em;text-transform:uppercase;direction:ltr}
</style></head><body>
<div class="light l4"></div><div class="light l1"></div><div class="light l2"></div><div class="light l3"></div>
<div class="wrap">
  <div class="mark">femio</div>
  <div>
    <div class="copy">${description}</div>
    <div class="tag" style="margin-top:28px">femioapp.com</div>
  </div>
</div>
</body></html>`;

const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1200, height: 630 }, deviceScaleFactor: 1 });
for (const locale of LOCALES) {
  const messages = JSON.parse(readFileSync(join("messages", `${locale}.json`), "utf8"));
  await page.setContent(html(locale, messages.meta.description), { waitUntil: "networkidle" });
  await page.waitForTimeout(800);
  const file = join(out, `${locale}.png`);
  await page.screenshot({ path: file, type: "png" });
  console.log("wrote", file);
}
await browser.close();
