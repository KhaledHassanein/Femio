#!/usr/bin/env node
/**
 * Renders one Markdown document as a single offline HTML file in Dusk Bloom
 * colours, for guides that must open on a locked laptop with no network.
 * Usage: node scripts/docs/md-to-html.mjs <in.md> <out.html> ["Title"]
 * Uses `marked` (a pinned root devDependency).
 */
import { createRequire } from "node:module";
import { readFileSync, writeFileSync } from "node:fs";
import { basename } from "node:path";

const require = createRequire(import.meta.url);
const { marked } = require("marked");

const [input, output, titleArg] = process.argv.slice(2);
if (!input || !output) {
  console.error("usage: md-to-html.mjs <in.md> <out.html> [title]");
  process.exit(1);
}
const md = readFileSync(input, "utf8");
const title = titleArg ?? (md.match(/^#\s+(.+)$/m)?.[1] ?? basename(input));
const body = marked.parse(md);

const css = `
:root{--bg:#FBF7F3;--surface:#fff;--ink:#24141F;--muted:#5E4D57;--plum:#8A3572;--rose:#BF2F59;--line:#E9DFD9;--sunken:#F4EDE8}
@media(prefers-color-scheme:dark){:root{--bg:#140D14;--surface:#1E1520;--ink:#F6EEF2;--muted:#C9B8C2;--plum:#DDA2C8;--line:#33262F;--sunken:#19111A}}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font:16px/1.6 "Plus Jakarta Sans",system-ui,sans-serif}
main{max-width:760px;margin:0 auto;padding:32px 20px 80px}
h1,h2,h3{font-family:Newsreader,Georgia,serif;letter-spacing:-.01em;line-height:1.2}h1{font-size:34px;color:var(--plum)}h2{font-size:26px;margin-top:48px;border-top:1px solid var(--line);padding-top:24px}h3{font-size:20px;margin-top:28px}
a{color:var(--plum)}code{background:var(--sunken);padding:1px 5px;border-radius:6px;font-size:.92em}pre{background:var(--sunken);padding:14px;border-radius:12px;overflow:auto}pre code{background:none;padding:0}
table{border-collapse:collapse;width:100%;font-size:15px;margin:16px 0}th,td{text-align:start;padding:8px 10px;border-bottom:1px solid var(--line);vertical-align:top}th{color:var(--muted);font-weight:600}
blockquote{margin:16px 0;padding:12px 16px;border-inline-start:4px solid var(--plum);background:var(--surface);border-radius:0 12px 12px 0}
hr{border:0;border-top:1px solid var(--line);margin:32px 0}strong{font-weight:600}
.meta{color:var(--muted);font-size:14px}
`;
const html = `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>${title}</title><style>${css}</style></head><body><main><p class="meta">femio · generated ${new Date().toISOString().slice(0, 10)} from ${basename(input)}</p>${body}</main></body></html>`;
writeFileSync(output, html);
console.log("wrote", output, (html.length / 1024).toFixed(0), "KB");
