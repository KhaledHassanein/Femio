#!/usr/bin/env node
/**
 * Guard for the ready-made Tag Manager container (docs/34_GROWTH_OPS/gtm/femio-container.json).
 *
 * Why: on 2026-10-30 the owner's import failed with "File format is invalid" because the
 * event tags still referenced the configuration tag the retired way (a TAG_REFERENCE on
 * measurementIdOverride) and consentSettings was shaped like a Parameter. Tag Manager
 * validates the file before import and says little about why. This script checks the
 * shapes Tag Manager accepts today, so the next edit cannot reintroduce them:
 *
 *   1. valid JSON, exportFormatVersion 2, a WEB container;
 *   2. every GA4 event tag (type gaawe) sets measurementIdOverride as a TEMPLATE that
 *      references the constant variable holding the measurement id;
 *   3. every tag's consentSettings is {consentStatus, consentType: LIST} (the Tag resource
 *      of the Tag Manager API), and every GA4 tag requires analytics_storage;
 *   4. every firing trigger id exists (or is a built-in trigger id), and every {{variable}}
 *      referenced in a tag exists (user-defined or built-in);
 *   5. none of the owner's ids is in the file: the measurement id is the placeholder, the
 *      container id is the placeholder. The file must stay shareable.
 *
 * Exit 1 with every problem listed; exit 0 with one line otherwise.
 */
import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const FILE = join(HERE, "..", "docs", "34_GROWTH_OPS", "gtm", "femio-container.json");

/** Tag Manager's built-in trigger ids (All Pages, Initialization, Consent Initialization). */
const BUILT_IN_TRIGGERS = new Set(["2147479553", "2147479572", "2147479573"]);
const MEASUREMENT_ID_PLACEHOLDER = "G-REPLACE-ME";
const CONTAINER_ID_PLACEHOLDER = "GTM-REPLACE";

const errors = [];
let data;
try {
  data = JSON.parse(readFileSync(FILE, "utf8"));
} catch (e) {
  console.error(`✗ GTM container guard: ${FILE} is not valid JSON (${e.message})`);
  process.exit(1);
}

const cv = data.containerVersion ?? {};
if (data.exportFormatVersion !== 2) errors.push("exportFormatVersion must be 2");
if (!Array.isArray(cv.container?.usageContext) || !cv.container.usageContext.includes("WEB")) errors.push("container.usageContext must include WEB");
if (cv.container?.publicId !== CONTAINER_ID_PLACEHOLDER) errors.push(`container.publicId must stay ${CONTAINER_ID_PLACEHOLDER} (the owner's id never enters the repo)`);

const tags = cv.tag ?? [];
const triggers = new Set((cv.trigger ?? []).map((t) => String(t.triggerId)));
const variables = new Set((cv.variable ?? []).map((v) => v.name));
const builtIns = new Set((cv.builtInVariable ?? []).map((v) => v.name));
const constants = (cv.variable ?? []).filter((v) => v.type === "c");
const idConstant = constants.find((v) => /measurement id/i.test(v.name));
if (!idConstant) errors.push("no constant variable (type c) named like 'measurement id'");
else {
  const value = idConstant.parameter?.find((p) => p.key === "value")?.value;
  if (value !== MEASUREMENT_ID_PLACEHOLDER) errors.push(`constant '${idConstant.name}' must hold ${MEASUREMENT_ID_PLACEHOLDER}, found '${value}'`);
}
const idRef = idConstant ? `{{${idConstant.name}}}` : null;

function walkValues(node, out) {
  if (node == null) return out;
  if (Array.isArray(node)) {
    for (const n of node) walkValues(n, out);
  } else if (typeof node === "object") {
    for (const v of Object.values(node)) walkValues(v, out);
  } else if (typeof node === "string") out.push(node);
  return out;
}

for (const tag of tags) {
  const where = `tag '${tag.name}'`;
  if (tag.type === "gaawe") {
    const p = (tag.parameter ?? []).find((x) => x.key === "measurementIdOverride");
    if (!p) errors.push(`${where}: measurementIdOverride is missing`);
    else if (p.type !== "TEMPLATE" || p.value !== idRef) errors.push(`${where}: measurementIdOverride must be TEMPLATE ${idRef}, found ${p.type} '${p.value}'`);
  }
  if (tag.type === "googtag") {
    const p = (tag.parameter ?? []).find((x) => x.key === "tagId");
    if (!p || p.type !== "TEMPLATE" || p.value !== idRef) errors.push(`${where}: tagId must be TEMPLATE ${idRef}`);
  }
  const cs = tag.consentSettings;
  if (!cs || typeof cs.consentStatus !== "string" || cs.consentType?.type !== "LIST" || !Array.isArray(cs.consentType?.list)) {
    errors.push(`${where}: consentSettings must be {consentStatus, consentType: {type: LIST, list}}`);
  } else if (tag.type === "gaawe" || tag.type === "googtag") {
    const types = cs.consentType.list.map((x) => x.value);
    if (cs.consentStatus !== "NEEDED" || !types.includes("analytics_storage")) errors.push(`${where}: a GA4 tag must require analytics_storage (ADR-075)`);
  }
  for (const id of tag.firingTriggerId ?? []) {
    if (!triggers.has(String(id)) && !BUILT_IN_TRIGGERS.has(String(id))) errors.push(`${where}: firing trigger ${id} does not exist`);
  }
  for (const text of walkValues(tag.parameter, [])) {
    for (const m of text.matchAll(/\{\{([^}]+)\}\}/g)) {
      const name = m[1];
      if (!variables.has(name) && !builtIns.has(name) && !name.startsWith("_")) errors.push(`${where}: variable {{${name}}} does not exist`);
    }
  }
}

const leaked = walkValues(cv, []).filter((s) => /\bG-[A-Z0-9]{6,}\b/.test(s) && !s.includes(MEASUREMENT_ID_PLACEHOLDER));
if (leaked.length) errors.push(`a real-looking measurement id is in the file: ${leaked[0]}`);

if (errors.length) {
  console.error("✗ GTM container guard:");
  for (const e of errors) console.error(`  - ${e}`);
  process.exit(1);
}
console.log(`✓ GTM container guard: ${tags.length} tags, ${triggers.size} triggers, ${variables.size} variables; event tags reference the measurement-id constant, consent settings in the API shape, no owner id in the file.`);
