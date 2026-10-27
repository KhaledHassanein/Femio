#!/usr/bin/env node
/**
 * Generates every icon surface from the one Dusk Bloom source
 * (docs/33_REBUILD_V3/02_DESIGN_SPEC.md §5).
 *
 * Source: assets/brand/logo/femio-app-icon-dusk.svg (full-bleed, the bloom inside
 * the 80% safe zone, so one image serves both the plain and the maskable purpose).
 *
 * Writes:
 *   apps/web/public/favicon.ico                     16 + 32 + 48 (PNG-in-ICO)
 *   apps/web/public/icons/icon-{16,32,180,192,512}.png
 *   apps/web/public/icons/maskable-{192,512}.png
 *   apps/web/src/app/icon.svg and public/icons/app-icon.svg (copies of the source)
 *   apps/mobile/android/app/src/main/res/mipmap-{density}/ic_launcher.png (legacy launcher)
 *   apps/mobile/android/app/src/main/res/mipmap-{density}/ic_launcher_foreground.png (adaptive)
 *   apps/mobile/android/app/src/main/res/drawable/splash_mark.png (+ xxhdpi)
 *
 * Why a script: the icon set drifted to three palettes because each file was
 * hand-exported once (study report 11). Regenerating from one source makes the
 * palette a single decision. Usage: node scripts/brand/generate-icons.mjs
 */
import sharp from "sharp";
import { copyFileSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const ROOT = process.cwd();
const SOURCE = join(ROOT, "assets/brand/logo/femio-app-icon-dusk.svg");
const WEB_PUBLIC = join(ROOT, "apps/web/public");
const WEB_ICONS = join(WEB_PUBLIC, "icons");
const ANDROID_RES = join(ROOT, "apps/mobile/android/app/src/main/res");

/** plum-900 from femio.tokens.css: the splash and the adaptive-icon background. */
export const PLUM_900 = "#3F1534";

const svg = readFileSync(SOURCE);

async function png(size, { foregroundOnly = false } = {}) {
  if (!foregroundOnly) return sharp(svg, { density: 384 }).resize(size, size).png().toBuffer();
  // Adaptive foreground: the bloom alone on transparency, drawn into the inner
  // 66% of a 108dp canvas (Android's safe zone for the foreground layer).
  const inner = Math.round(size * 0.66);
  const mark = readFileSync(SOURCE, "utf8").replace(/<rect width="512" height="512" fill="url\(#dusk\)"\/>/, "");
  const bloom = await sharp(Buffer.from(mark), { density: 384 }).resize(inner, inner).png().toBuffer();
  return sharp({ create: { width: size, height: size, channels: 4, background: { r: 0, g: 0, b: 0, alpha: 0 } } })
    .composite([{ input: bloom, gravity: "centre" }])
    .png()
    .toBuffer();
}

/** An ICO container holding PNG images: header, one directory entry per image, then the data. */
function ico(images) {
  const header = Buffer.alloc(6);
  header.writeUInt16LE(0, 0);
  header.writeUInt16LE(1, 2);
  header.writeUInt16LE(images.length, 4);
  const entries = [];
  let offset = 6 + 16 * images.length;
  for (const { size, data } of images) {
    const e = Buffer.alloc(16);
    e.writeUInt8(size >= 256 ? 0 : size, 0);
    e.writeUInt8(size >= 256 ? 0 : size, 1);
    e.writeUInt8(0, 2);
    e.writeUInt8(0, 3);
    e.writeUInt16LE(1, 4);
    e.writeUInt16LE(32, 6);
    e.writeUInt32LE(data.length, 8);
    e.writeUInt32LE(offset, 12);
    offset += data.length;
    entries.push(e);
  }
  return Buffer.concat([header, ...entries, ...images.map((i) => i.data)]);
}

mkdirSync(WEB_ICONS, { recursive: true });

// Web.
for (const size of [16, 32, 180, 192, 512]) writeFileSync(join(WEB_ICONS, `icon-${size}.png`), await png(size));
for (const size of [192, 512]) writeFileSync(join(WEB_ICONS, `maskable-${size}.png`), await png(size));
writeFileSync(join(WEB_PUBLIC, "favicon.ico"), ico(await Promise.all([16, 32, 48].map(async (size) => ({ size, data: await png(size) })))));
copyFileSync(SOURCE, join(WEB_ICONS, "app-icon.svg"));
copyFileSync(SOURCE, join(ROOT, "apps/web/src/app/icon.svg"));

// Android: legacy launcher at each density, adaptive foreground, splash mark.
const DENSITIES = { mdpi: 1, hdpi: 1.5, xhdpi: 2, xxhdpi: 3, xxxhdpi: 4 };
for (const [name, scale] of Object.entries(DENSITIES)) {
  const dir = join(ANDROID_RES, `mipmap-${name}`);
  mkdirSync(dir, { recursive: true });
  writeFileSync(join(dir, "ic_launcher.png"), await png(Math.round(48 * scale)));
  writeFileSync(join(dir, "ic_launcher_foreground.png"), await png(Math.round(108 * scale), { foregroundOnly: true }));
}
for (const [name, scale] of Object.entries({ "": 1, "-xxhdpi": 3 })) {
  const dir = join(ANDROID_RES, `drawable${name}`);
  mkdirSync(dir, { recursive: true });
  writeFileSync(join(dir, "splash_mark.png"), await png(Math.round(96 * scale), { foregroundOnly: true }));
}

console.log("icons generated from", SOURCE);
