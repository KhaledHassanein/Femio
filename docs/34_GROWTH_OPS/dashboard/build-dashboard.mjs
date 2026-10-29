#!/usr/bin/env node
/**
 * Builds the go-live dashboard page (R6.12).
 *
 * Reads the three data files beside it and writes `index.html`: the template with the data
 * embedded as one `DATA` constant, so the published artifact is a single static page that
 * needs no network. The page's state (ticks, flags, notes, the two decisions) is not here:
 * it lives in the artifact's database and is read back by sessions with the ArtifactData tool.
 *
 *   node docs/34_GROWTH_OPS/dashboard/build-dashboard.mjs
 *
 * Then publish `index.html` to the existing artifact (README.md). Fails loudly when a data
 * file is not valid JSON, when an item id is duplicated or a `dependsOn` points nowhere, or
 * when a request `blocks` an unknown step, so a broken dashboard never reaches the owner.
 */
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const read = (name) => JSON.parse(readFileSync(join(here, name), "utf8"));

const items = read("items.json");
const requests = read("requests.json");
const log = read("log.json");

const ids = new Set();
for (const phase of items.phases) {
  for (const item of phase.items) {
    if (ids.has(item.id)) throw new Error(`duplicate step id: ${item.id}`);
    ids.add(item.id);
    for (const key of ["title", "owner", "why", "steps", "doneWhen"]) {
      if (item[key] === undefined) throw new Error(`step ${item.id} lacks ${key}`);
    }
  }
}
for (const phase of items.phases) {
  for (const item of phase.items) {
    for (const dep of item.dependsOn ?? []) {
      if (!ids.has(dep)) throw new Error(`step ${item.id} depends on unknown step ${dep}`);
    }
  }
}
for (const request of requests.requests) {
  for (const id of request.blocks ?? []) {
    if (!ids.has(id)) throw new Error(`request ${request.id} blocks unknown step ${id}`);
  }
}
const secretLike = /\b(GTM-[A-Z0-9]{6,}|G-[A-Z0-9]{8,}|ca-pub-\d{10,}|pub-\d{10,}|AIza[0-9A-Za-z_-]{20,})\b/;
for (const text of [JSON.stringify(requests), JSON.stringify(log)]) {
  if (secretLike.test(text)) throw new Error("an id that belongs in Vercel or a password manager is in a data file");
}

const data = {
  generated: items.generated,
  phases: items.phases,
  requests: requests.requests,
  log: { entries: log.entries },
};
const template = readFileSync(join(here, "template.html"), "utf8");
const marker = "/*__DATA__*/";
if (!template.includes(marker)) throw new Error("template.html lacks the data marker");
// `</script` inside a string would end the script element early; escape the slash.
const json = JSON.stringify(data).replace(/<\//g, "<\\/");
const html = template.replace(marker, `const DATA = ${json};`);
writeFileSync(join(here, "index.html"), html);
console.log(`dashboard built: ${ids.size} steps in ${items.phases.length} phases, ${requests.requests.length} requests, ${log.entries.length} log entries, ${(html.length / 1024).toFixed(0)} KB`);
