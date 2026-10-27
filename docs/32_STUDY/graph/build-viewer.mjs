// Builds graph/index.html: a self-contained, offline viewer of the merged
// knowledge graph (no CDN, no dependencies). Why: the graph must be readable by
// Khaled on any machine, including a locked laptop, and by any agent that opens
// the file. Usage: node docs/32_STUDY/graph/build-viewer.mjs
import { readFileSync, writeFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const dir = dirname(fileURLToPath(import.meta.url));
const graph = readFileSync(join(dir, "femio-graph.json"), "utf8").replace(/<\/script/gi, "<\\/script");

const css = `
:root{--bg:#FBF7F3;--card:#fff;--ink:#24141F;--muted:#5E4D57;--plum:#8A3572;--line:#E9DFD9}
@media(prefers-color-scheme:dark){:root{--bg:#140D14;--card:#1E1520;--ink:#F6EEF2;--muted:#C9B8C2;--line:#33262F}}
*{box-sizing:border-box}
body{margin:0;font:14px/1.5 system-ui,"Plus Jakarta Sans",sans-serif;background:var(--bg);color:var(--ink);display:grid;grid-template-rows:auto 1fr;height:100vh}
header{display:flex;flex-wrap:wrap;gap:8px 16px;align-items:center;padding:10px 16px;border-bottom:1px solid var(--line);background:var(--card)}
header h1{font:600 18px Newsreader,Georgia,serif;margin:0 12px 0 0}
label{display:inline-flex;gap:6px;align-items:center;color:var(--muted)}
select,input{font:inherit;padding:4px 8px;border:1px solid var(--line);border-radius:8px;background:var(--bg);color:var(--ink)}
main{position:relative;overflow:hidden}
canvas{width:100%;height:100%;display:block;cursor:grab}
#info{position:absolute;top:12px;right:12px;width:320px;max-height:calc(100% - 24px);overflow:auto;background:var(--card);border:1px solid var(--line);border-radius:16px;padding:12px 14px;box-shadow:0 8px 24px rgb(138 53 114/.18);display:none}
#info h2{margin:0 0 6px;font-size:15px}
#info dl{margin:0;display:grid;grid-template-columns:auto 1fr;gap:2px 10px;color:var(--muted)}
#info dd{margin:0;color:var(--ink);word-break:break-all}
#info ul{padding-left:18px;margin:6px 0}
#legend{display:flex;gap:10px;flex-wrap:wrap;color:var(--muted)}
#legend span::before{content:"";display:inline-block;width:10px;height:10px;border-radius:50%;margin-right:4px;background:var(--c)}
#stats{color:var(--muted);margin-left:auto}
`;

const js = `
// Force-directed layout on a canvas. Nodes are coloured by status (the question
// the rebuild asks of every file), sized by degree, and seeded by area.
const G = JSON.parse(document.getElementById("data").textContent);
const COLOR = { live: "#2F7163", "app-only": "#C08A2E", dead: "#BF2F59", duplicate: "#C95E33", unknown: "#8E7B86" };
const areas = [...new Set(G.nodes.map((n) => n.area))].sort();
const types = [...new Set(G.nodes.map((n) => n.type))].sort();
const fill = (id, list) => { const s = document.getElementById(id); for (const v of list) { const o = document.createElement("option"); o.value = v; o.textContent = v; s.appendChild(o); } };
fill("area", areas); fill("type", types);
const byId = new Map(G.nodes.map((n) => [n.id, n]));
const deg = new Map();
for (const e of G.edges) { deg.set(e.from, (deg.get(e.from) || 0) + 1); deg.set(e.to, (deg.get(e.to) || 0) + 1); }
const cv = document.getElementById("c"), ctx = cv.getContext("2d");
let W, H, dpr = devicePixelRatio || 1;
function resize() { W = cv.clientWidth; H = cv.clientHeight; cv.width = W * dpr; cv.height = H * dpr; ctx.setTransform(dpr, 0, 0, dpr, 0, 0); }
addEventListener("resize", resize); resize();
const areaAngle = new Map(areas.map((a, i) => [a, (i / areas.length) * Math.PI * 2]));
for (const n of G.nodes) { const a = areaAngle.get(n.area); const r = Math.min(W, H) * 0.33; n.x = W / 2 + Math.cos(a) * r + (Math.random() - 0.5) * 80; n.y = H / 2 + Math.sin(a) * r + (Math.random() - 0.5) * 80; n.vx = 0; n.vy = 0; }
let view = { x: 0, y: 0, k: 1 }, sel = null, hover = null, drag = null, pan = null, alpha = 1;
const $ = (id) => document.getElementById(id);
function visible() { const A = $("area").value, S = $("status").value, T = $("type").value, Q = $("q").value.toLowerCase(); return G.nodes.filter((n) => (!A || n.area === A) && (!S || n.status === S) && (!T || n.type === T) && (!Q || n.id.includes(Q) || (n.label || "").toLowerCase().includes(Q) || (n.path || "").toLowerCase().includes(Q))); }
let vis = [], visSet = new Set(), visEdges = [];
function refilter() { vis = visible(); visSet = new Set(vis.map((n) => n.id)); visEdges = G.edges.filter((e) => visSet.has(e.from) && visSet.has(e.to)); alpha = 1; $("stats").textContent = vis.length + " nodes · " + visEdges.length + " edges"; }
for (const id of ["area", "status", "type", "q"]) $(id).addEventListener("input", refilter);
refilter();
function step() {
  if (alpha < 0.005) return; const k = alpha;
  const cell = 60, buckets = new Map();
  for (const n of vis) { const key = ((n.x / cell) | 0) + "," + ((n.y / cell) | 0); (buckets.get(key) || buckets.set(key, []).get(key)).push(n); }
  for (const n of vis) { const bx = (n.x / cell) | 0, by = (n.y / cell) | 0; for (let i = -1; i <= 1; i++) for (let j = -1; j <= 1; j++) { const b = buckets.get((bx + i) + "," + (by + j)); if (!b) continue; for (const m of b) { if (m === n) continue; const dx = n.x - m.x, dy = n.y - m.y, d2 = dx * dx + dy * dy + 0.01; if (d2 > cell * cell * 4) continue; const f = (900 * k) / d2; n.vx += dx * f; n.vy += dy * f; } } }
  for (const e of visEdges) { const a = byId.get(e.from), b = byId.get(e.to); const dx = b.x - a.x, dy = b.y - a.y, d = Math.hypot(dx, dy) || 1, f = (d - 70) * 0.02 * k; a.vx += (dx / d) * f; a.vy += (dy / d) * f; b.vx -= (dx / d) * f; b.vy -= (dy / d) * f; }
  for (const n of vis) { const a = areaAngle.get(n.area), r = Math.min(W, H) * 0.3, cx = W / 2 + Math.cos(a) * r, cy = H / 2 + Math.sin(a) * r; n.vx += (cx - n.x) * 0.004 * k; n.vy += (cy - n.y) * 0.004 * k; if (drag === n) continue; n.x += n.vx; n.y += n.vy; n.vx *= 0.6; n.vy *= 0.6; }
  alpha *= 0.985;
}
function draw() {
  ctx.clearRect(0, 0, W, H); ctx.save(); ctx.translate(view.x, view.y); ctx.scale(view.k, view.k);
  const focus = sel || hover; const nbr = new Set();
  if (focus) for (const e of visEdges) { if (e.from === focus.id) nbr.add(e.to); if (e.to === focus.id) nbr.add(e.from); }
  for (const e of visEdges) { const a = byId.get(e.from), b = byId.get(e.to); const lit = focus && (e.from === focus.id || e.to === focus.id); ctx.strokeStyle = lit ? "#8A3572" : "rgba(142,123,134,.25)"; ctx.lineWidth = (lit ? 2 : 1) / view.k; ctx.beginPath(); ctx.moveTo(a.x, a.y); ctx.lineTo(b.x, b.y); ctx.stroke(); }
  const ink = getComputedStyle(document.body).color;
  for (const n of vis) {
    const r = 3 + Math.min(9, Math.sqrt(deg.get(n.id) || 0)); const dim = focus && n !== focus && !nbr.has(n.id);
    ctx.globalAlpha = dim ? 0.25 : 1; ctx.fillStyle = COLOR[n.status] || COLOR.unknown; ctx.beginPath(); ctx.arc(n.x, n.y, r, 0, 7); ctx.fill();
    if (n === focus) { ctx.strokeStyle = ink; ctx.lineWidth = 2 / view.k; ctx.stroke(); }
    if (view.k > 1.4 || n === focus || nbr.has(n.id) || r > 8) { ctx.fillStyle = ink; ctx.font = 11 / view.k + "px system-ui"; ctx.fillText(n.label || n.id, n.x + r + 3, n.y + 4 / view.k); }
    ctx.globalAlpha = 1;
  }
  ctx.restore();
}
(function loop() { step(); draw(); requestAnimationFrame(loop); })();
function pick(ev) { const x = (ev.offsetX - view.x) / view.k, y = (ev.offsetY - view.y) / view.k; let best = null, bd = 14 / view.k; for (const n of vis) { const d = Math.hypot(n.x - x, n.y - y); if (d < bd) { bd = d; best = n; } } return best; }
cv.addEventListener("mousemove", (ev) => { if (drag) { drag.x = (ev.offsetX - view.x) / view.k; drag.y = (ev.offsetY - view.y) / view.k; alpha = Math.max(alpha, 0.3); return; } if (pan) { view.x += ev.movementX; view.y += ev.movementY; return; } hover = pick(ev); cv.style.cursor = hover ? "pointer" : "grab"; });
cv.addEventListener("mousedown", (ev) => { const n = pick(ev); if (n) drag = n; else pan = true; });
addEventListener("mouseup", () => { drag = null; pan = null; });
cv.addEventListener("click", (ev) => { const n = pick(ev); sel = n; show(n); });
cv.addEventListener("wheel", (ev) => { ev.preventDefault(); const f = ev.deltaY < 0 ? 1.1 : 0.9; view.x = ev.offsetX - (ev.offsetX - view.x) * f; view.y = ev.offsetY - (ev.offsetY - view.y) * f; view.k *= f; }, { passive: false });
function esc(s) { return String(s).replace(/[&<>]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;" })[c]); }
function show(n) {
  const el = $("info"); if (!n) { el.style.display = "none"; return; } el.style.display = "block";
  const out = G.edges.filter((e) => e.from === n.id), inn = G.edges.filter((e) => e.to === n.id);
  el.innerHTML = "<h2>" + esc(n.label || n.id) + "</h2><dl><dt>id</dt><dd>" + esc(n.id) + "</dd><dt>type</dt><dd>" + esc(n.type) + "</dd><dt>status</dt><dd>" + esc(n.status) + "</dd><dt>area</dt><dd>" + esc(n.area) + "</dd><dt>path</dt><dd>" + esc(n.path || "") + "</dd></dl>" + (n.note ? "<p>" + esc(n.note) + "</p>" : "") + "<b>→ " + out.length + "</b><ul>" + out.map((e) => "<li>" + esc(e.kind) + " " + esc(e.to) + "</li>").join("") + "</ul><b>← " + inn.length + "</b><ul>" + inn.map((e) => "<li>" + esc(e.kind) + " " + esc(e.from) + "</li>").join("") + "</ul>";
}
`;

const html = `<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Femio knowledge graph</title><style>${css}</style></head>
<body>
<header><h1>femio · knowledge graph</h1>
<label>Area <select id="area"><option value="">all</option></select></label>
<label>Status <select id="status"><option value="">all</option><option>live</option><option>app-only</option><option>dead</option><option>duplicate</option><option>unknown</option></select></label>
<label>Type <select id="type"><option value="">all</option></select></label>
<label>Find <input id="q" placeholder="id, label or path"></label>
<div id="legend"><span style="--c:#2F7163">live</span><span style="--c:#C08A2E">app-only (closed tracker)</span><span style="--c:#BF2F59">dead</span><span style="--c:#C95E33">duplicate</span><span style="--c:#8E7B86">unknown</span></div>
<div id="stats"></div></header>
<main><canvas id="c"></canvas><aside id="info"></aside></main>
<script id="data" type="application/json">${graph}</script>
<script>${js}</script>
</body></html>`;

writeFileSync(join(dir, "index.html"), html);
console.log("wrote index.html", (html.length / 1024).toFixed(0), "KB");
