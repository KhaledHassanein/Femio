#!/usr/bin/env node
/**
 * Generates the Android launcher icon and the Play store icon from ONE source,
 * assets/brand/logo/femio-launcher-icon.svg (the premium Dusk Bloom mark).
 *
 * Why a separate script from generate-icons.mjs: the owner asked that only the
 * launcher icon be premium (rich gradient ground, large crafted petals) while
 * the web favicon and in-app graphics stay as they are.
 *
 * Writes:
 *   mipmap-{mdpi..xxxhdpi}/ic_launcher.png             legacy square launcher (48dp)
 *   mipmap-{mdpi..xxxhdpi}/ic_launcher_background.png  adaptive ground layer (108dp)
 *   mipmap-{mdpi..xxxhdpi}/ic_launcher_foreground.png  adaptive bloom layer (108dp, transparent)
 *   docs/store/graphics/icon-512.png                   Play store icon
 *
 * The adaptive foreground keeps every petal tip inside Android's 66dp safe
 * circle (radius 29% of the canvas), so no launcher mask can clip the flower.
 * Usage: node scripts/brand/generate-launcher-icon.mjs   (from the repo root)
 */
import sharp from "sharp";
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const ROOT = process.cwd();
const SOURCE = readFileSync(join(ROOT, "assets/brand/logo/femio-launcher-icon.svg"), "utf8");
const ANDROID_RES = join(ROOT, "apps/mobile/android/app/src/main/res");
const STORE_ICON = join(ROOT, "docs/store/graphics/icon-512.png");

/** Petal tip radius in the source's own units (the petal path reaches y = -212). */
const PETAL_TIP = 212;
/** Foreground petal tip as a share of the adaptive canvas (inside the 66dp safe circle). */
const SAFE_RADIUS = 0.29;
const DENSITIES = { mdpi: 1, hdpi: 1.5, xhdpi: 2, xxhdpi: 3, xxxhdpi: 4 };

const render = (svg, size) => sharp(Buffer.from(svg), { density: 384 }).resize(size, size).png().toBuffer();

/** Removes the group with the given id (the groups here never nest another group of the same id). */
function without(svg, id) {
  const start = svg.indexOf(`<g id="${id}"`);
  const open = svg.indexOf("\n  <g id=", start + 1);
  const end = id === "bg" ? open : svg.lastIndexOf("</svg>");
  return svg.slice(0, start) + svg.slice(end);
}

const full = SOURCE;
const backgroundOnly = without(SOURCE, "bloom");
const foregroundOnly = without(SOURCE, "bg").replace("scale(0.96)", `scale(${((SAFE_RADIUS * 512) / PETAL_TIP).toFixed(4)})`);

for (const [name, scale] of Object.entries(DENSITIES)) {
  const dir = join(ANDROID_RES, `mipmap-${name}`);
  mkdirSync(dir, { recursive: true });
  writeFileSync(join(dir, "ic_launcher.png"), await render(full, Math.round(48 * scale)));
  writeFileSync(join(dir, "ic_launcher_background.png"), await render(backgroundOnly, Math.round(108 * scale)));
  writeFileSync(join(dir, "ic_launcher_foreground.png"), await render(foregroundOnly, Math.round(108 * scale)));
}
writeFileSync(STORE_ICON, await render(full, 512));
console.log("launcher icon generated from assets/brand/logo/femio-launcher-icon.svg");
