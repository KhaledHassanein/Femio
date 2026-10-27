// Merges the twelve per-area study graphs into one knowledge graph.
// Why: each study agent mapped its own area with shared id rules; this file
// joins them, resolves cross-area edges, and reports what is dangling so the
// merged graph can be trusted before anything is drawn from it.
// Usage: node docs/32_STUDY/graph/merge.mjs  → writes femio-graph.json + stats to stdout
import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
const dir = dirname(fileURLToPath(import.meta.url));
const files = readdirSync(dir).filter((f) => /^\d\d-.*\.json$/.test(f)).sort();
const nodes = new Map(); const edges = []; const dup = [];
for (const f of files) {
  const g = JSON.parse(readFileSync(join(dir, f), "utf8"));
  for (const n of g.nodes) {
    if (nodes.has(n.id)) dup.push(n.id); else nodes.set(n.id, { ...n, area: g.area ?? f });
  }
  for (const e of g.edges) edges.push({ ...e, area: g.area ?? f });
}
const dangling = edges.filter((e) => !nodes.has(e.from) || !nodes.has(e.to));
const byType = {}, byStatus = {}, byArea = {};
for (const n of nodes.values()) { byType[n.type] = (byType[n.type] ?? 0) + 1; byStatus[n.status] = (byStatus[n.status] ?? 0) + 1; byArea[n.area] = (byArea[n.area] ?? 0) + 1; }
writeFileSync(join(dir, "femio-graph.json"), JSON.stringify({ generated: new Date().toISOString().slice(0, 10), nodes: [...nodes.values()], edges: edges.filter((e) => nodes.has(e.from) && nodes.has(e.to)) }, null, 1));
console.log(JSON.stringify({ files: files.length, nodes: nodes.size, edges: edges.length, dangling: dangling.length, duplicateIds: dup.length, byType, byStatus, byArea }, null, 1));
console.log("sample dangling:", dangling.slice(0, 12).map((e) => `${e.from}->${e.to}`).join(", "));
