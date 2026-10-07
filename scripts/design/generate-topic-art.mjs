/**
 * Generates the Learn hub's topic covers (v3 P2.4): one SVG per topic in
 * apps/web/public/art/, coloured from femio.tokens.css.
 *
 * Why static files and not inline SVG: inline, every card carried its own SVG twice
 * (once in the HTML, once in the React payload). With ~95 cards the Learn page
 * weighed 484 KB of HTML against a 50 KB budget. As files, the browser fetches ten
 * small images once and caches them; each card varies only by a background
 * position and a mirror, a few bytes.
 *
 * Colours are read from the token file rather than retyped, so the art follows a
 * palette change. Re-run after editing `--art-*` or the primitives they point at:
 *   node scripts/design/generate-topic-art.mjs
 */
import { readFileSync, writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const root = join(dirname(fileURLToPath(import.meta.url)), "../..");
const css = readFileSync(join(root, "assets/brand/tokens/femio.tokens.css"), "utf8");
// Light-mode declarations only (the art is not themed).
const light = css.slice(0, css.search(/^\[data-theme="dark"\]\s*\{/m));
const decl = new Map([...light.matchAll(/(--[a-z0-9-]+)\s*:\s*([^;]+);/gi)].map((m) => [m[1], m[2].trim()]));
function resolve(name, depth = 0) {
  const v = decl.get(name);
  if (!v || depth > 8) throw new Error(`token ${name} not found`);
  const ref = /^var\((--[a-z0-9-]+)\)$/i.exec(v);
  return ref ? resolve(ref[1], depth + 1) : v;
}

const PALETTE = {
  ttc: ["--art-sage", "--art-saffron-soft", "--art-cream", "--art-saffron"],
  weeks: ["--art-peach", "--art-rose-soft", "--art-cream", "--art-rose"],
  pregnancy: ["--art-rose", "--art-peach-soft", "--art-cream", "--art-saffron"],
  afterBirth: ["--art-plum", "--art-rose-soft", "--art-rose-soft", "--art-peach"],
  newborn: ["--art-peach", "--art-sage-soft", "--art-cream", "--art-sage"],
  cycles: ["--art-rose", "--art-plum-soft", "--art-cream", "--art-plum"],
  conditions: ["--art-plum", "--art-saffron-soft", "--art-plum-soft", "--art-saffron"],
  teens: ["--art-peach", "--art-rose-soft", "--art-cream", "--art-plum"],
  menopause: ["--art-saffron", "--art-plum-soft", "--art-cream", "--art-plum"],
  more: ["--art-plum", "--art-peach-soft", "--art-cream", "--art-rose"],
};

function bloom(cx, cy, r, n, rot, fill, opacity, accent) {
  const petals = Array.from({ length: n }, (_, i) => {
    const a = rot + (360 / n) * i;
    const o = (opacity + (i % 2) * 0.12).toFixed(2);
    return `<ellipse rx="${(r * 0.42).toFixed(1)}" ry="${r}" transform="rotate(${a}) translate(0 ${(-r * 0.55).toFixed(1)})" fill="${fill}" fill-opacity="${o}"/>`;
  }).join("");
  return `<g transform="translate(${cx} ${cy})">${petals}<circle r="${(r * 0.28).toFixed(1)}" fill="${accent}" fill-opacity=".9"/></g>`;
}

for (const [topic, [ground, glow, petal, accent]] of Object.entries(PALETTE)) {
  const [g, gl, p, a] = [ground, glow, petal, accent].map((t) => resolve(t));
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 480 240" preserveAspectRatio="xMidYMid slice">
<defs><radialGradient id="g" cx="85%" cy="15%" r="95%"><stop offset="0" stop-color="${gl}"/><stop offset="1" stop-color="${g}"/></radialGradient></defs>
<rect width="480" height="240" fill="url(#g)"/>
<circle cx="190" cy="168" r="44" fill="${a}" fill-opacity=".5"/>
${bloom(300, 110, 64, 6, 18, p, 0.32, a)}
${bloom(96, 54, 30, 5, 40, p, 0.22, a)}
${bloom(430, 205, 26, 5, 5, p, 0.2, a)}
</svg>
`;
  writeFileSync(join(root, "apps/web/public/art", `${topic}.svg`), svg);
}
console.log(`generated ${Object.keys(PALETTE).length} covers in apps/web/public/art`);
