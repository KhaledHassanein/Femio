#!/usr/bin/env node
/**
 * Femio content guard (P1.9.1) — mechanical enforcement of
 * `docs/content/CODEX_AUTHORING_BRIEF.md` over `docs/content/articles/*.md`.
 *
 * Same ratchet pattern as claims-lint / crisis-lint / analytics-lint: it fails loudly,
 * it refuses to report a pass on an empty scan, and every rule here is one a human
 * reviewer would otherwise perform by hand across 60 files — which is precisely the
 * kind of checking that degrades on the fortieth article. What it deliberately does
 * NOT do is judge medicine: whether a claim is *true*, whether a source *supports* it,
 * and whether the clinical picture is complete all remain a qualified clinician's call
 * in the CMS review gate. This guard buys that reviewer time by making sure nothing
 * mechanical reaches them.
 *
 * Usage:
 *   node scripts/content-lint.mjs               # structural + textual rules (offline)
 *   node scripts/content-lint.mjs --check-urls  # additionally resolve every source URL
 *   node scripts/content-lint.mjs --json        # machine-readable findings
 *
 * URL resolution is opt-in because it is the one rule that can fail for reasons that
 * have nothing to do with the content (network, rate limits, a guideline body's WAF).
 * Keeping it out of the default run means the default run is deterministic, and CI can
 * schedule the network check separately rather than turning a flaky guard into noise
 * that people learn to ignore.
 */
import { readFileSync, readdirSync, existsSync } from "node:fs";
import { join } from "node:path";
import { parseArticle, REQUIRED_KEYS, FrontMatterError } from "./lib/article-frontmatter.mjs";

const APP_DIR = "apps/web/src/app/[locale]";
const SITE_ORIGIN = "https://femioapp.com";

const argv = process.argv.slice(2);
const args = new Set(argv);
const CHECK_URLS = args.has("--check-urls");
const AS_JSON = args.has("--json");
// `--dir` exists so the rules can be run against deliberately-broken fixtures
// (scripts/content-lint.test.mjs). A guard nobody has watched fail is a guard
// nobody knows works.
const ARTICLES_DIR = argv.find((a) => a.startsWith("--dir="))?.slice("--dir=".length) ?? "docs/content/articles";

const findings = [];
const add = (file, rule, message) => findings.push({ file, rule, message });

const TRANSLATION_FILE = /^(.+)\.(ar|fr|es)\.md$/;
/** The two labels the brief fixes (§4, §8), as each locale writes them. */
const LABELS = {
  en: { doctor: "When to see a doctor", care: "Seek care now:" },
  ar: { doctor: "متى تطلبين المشورة الطبية؟", care: "اطلبي الرعاية الآن:" },
  fr: { doctor: "Quand consulter", care: "Consultez sans attendre :" },
  es: { doctor: "Cuándo consultar", care: "Busca atención ya:" },
};
const escapeRe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

/* ------------------------------------------------------------------ *
 * Route surface — derived from the App Router, never hand-maintained.
 * A hardcoded list would drift the moment someone adds or renames a
 * page, and would then vouch for links that 404 in production.
 * ------------------------------------------------------------------ */
function collectRoutes(dir, prefix, out, isPublic) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const name = entry.name;
    // Route groups `(public)` / `(app)` don't appear in the URL, but they do tell
    // us whether a page sits behind auth.
    if (name.startsWith("(") && name.endsWith(")")) {
      collectRoutes(join(dir, name), prefix, out, name === "(public)" ? true : name === "(app)" ? false : isPublic);
      continue;
    }
    if (name.startsWith("_") || name === "components") continue;
    const segment = `${prefix}/${name}`;
    if (existsSync(join(dir, name, "page.tsx"))) {
      out.set(segment, { dynamic: name.startsWith("["), isPublic });
    }
    collectRoutes(join(dir, name), segment, out, isPublic);
  }
}

const routes = new Map();
if (existsSync(APP_DIR)) {
  if (existsSync(join(APP_DIR, "page.tsx"))) routes.set("", { dynamic: false, isPublic: true });
  collectRoutes(APP_DIR, "", routes, true);
}

/** Resolve `/en/foo/bar` against the route table. Returns a verdict object. */
function resolveRoute(path, slugSet, locale = "en") {
  const m = path.match(new RegExp(`^/${locale}(/.*)?$`));
  if (!m) return { ok: false, why: `not an /${locale}-prefixed Femio path` };
  const rest = m[1] ?? "";
  const exact = routes.get(rest);
  if (exact) {
    return exact.isPublic ? { ok: true } : { ok: false, why: "links into the authenticated app" };
  }
  // Try dynamic: /learn/<slug>, /conditions/<slug>, /authors/<slug>
  const parts = rest.split("/").filter(Boolean);
  if (parts.length === 2) {
    const parent = `/${parts[0]}`;
    const dyn = [...routes.keys()].find((r) => r.startsWith(`${parent}/[`));
    if (dyn) {
      if (parts[0] === "learn" || parts[0] === "conditions") {
        return slugSet.has(parts[1])
          ? { ok: true }
          : { ok: false, why: `no article in this set has slug "${parts[1]}"` };
      }
      // e.g. /en/authors/<slug> — a CMS record we cannot verify from the repo.
      return { ok: true, unverifiable: true };
    }
  }
  return { ok: false, why: "no such route in apps/web" };
}

/* ------------------------------------------------------------------ *
 * Rule vocabulary
 * ------------------------------------------------------------------ */

/** Brief §2 — claim verbs, forbidden when *Femio* is the actor. */
const CLAIM_VERBS =
  /\b(diagnos(?:e|es|ed|ing|is)|treats?|treating|cures?|curing|prevents?|preventing|contracept(?:ion|ive|ives))\b/i;

/** Markers that make Femio (not a clinician or guideline) the subject of a sentence. */
const FEMIO_SUBJECT = /\b(femio|femio's|this app|the app|our app|we|our)\b/i;

/**
 * ADR-028(a) — decorative "medical" framing that the ADR renamed to clinician
 * framing. Deliberately narrow: the ADR is explicit that boundary statements
 * ("not medical advice", "seek urgent medical care", "not a medical device") keep
 * the word verbatim because they are the regulatory protection. Flagging those
 * would push an author to weaken exactly the sentence that must not weaken, so
 * this list names only the decorative uses.
 */
const DECORATIVE_FRAMING = [
  /medically[\s-]reviewed/i,
  /medical review (?:process|page|team|board)/i,
  /medical reviewer/i,
  /medical information/i,
  /medical website/i,
];

/**
 * Brief §8 — topics that must route to Femio's global crisis page. The routing is
 * deliberately number-free: a wrong or stale hotline number is itself a safety
 * failure, and Femio serves four locales across many countries.
 */
const CRISIS_TOPICS =
  /\b(suicid\w*|self-harm|harm(?:ing)? (?:yourself|myself|herself)|end (?:your|her) life|domestic (?:abuse|violence)|unable to stay safe)\b/i;

/** Brief §8 — a phone number anywhere is a safety failure (numbers go stale). */
const PHONE = /(?:\+\d[\d\s().-]{7,}\d)|(?:\b(?:tel|call)\s*:?\s*\d[\d\s().-]{5,}\d)|\b(?:11[28]|999|911|988)\b(?=\s*(?:for|to call|hotline|helpline))/i;

/** Brief §2 — the fertile-window sentence is approved wording, used verbatim. */
const FERTILE_SENTENCE =
  "These dates support conception planning and awareness. They are estimates, not a reliable way to avoid pregnancy.";

/** Brief §3 — sources that may never be cited. */
const BANNED_SOURCE_HOSTS = [
  "wikipedia.org",
  "healthline.com",
  "webmd.com",
  "flo.health",
  "clue.com",
  "medium.com",
  "reddit.com",
];

/** Strip fenced code, URLs and link targets so text rules see prose only. */
function proseOf(body) {
  return body
    .replace(/```[\s\S]*?```/g, " ")
    .replace(/\]\([^)]*\)/g, "] ")
    .replace(/https?:\/\/\S+/g, " ")
    .replace(/<!--[\s\S]*?-->/g, " ");
}

function sentencesOf(text) {
  return text
    .replace(/\n+/g, " ")
    .split(/(?<=[.!?])\s+/)
    .map((s) => s.trim())
    .filter(Boolean);
}

/* ------------------------------------------------------------------ *
 * Load
 * ------------------------------------------------------------------ */
let files = [];
try {
  files = readdirSync(ARTICLES_DIR)
    .filter((f) => f.endsWith(".md"))
    .sort();
} catch {
  /* handled by the empty-scan guard below */
}

// A guard that finds nothing to scan must fail, not pass — the lesson recorded in
// claims-lint: running from a package directory once produced a reassuring ✓ over
// zero files, a clean bill of health on nothing.
if (files.length === 0) {
  console.error(
    `✗ Content guard: no article drafts found in "${ARTICLES_DIR}".\n` +
      "Run it from the repo root (`pnpm content-lint`). Refusing to report a pass on nothing.",
  );
  process.exit(1);
}
if (routes.size === 0) {
  console.error(
    `✗ Content guard: no routes discovered under "${APP_DIR}".\n` +
      "Internal-link checking would vacuously pass. Run from the repo root.",
  );
  process.exit(1);
}

const parsed = [];
for (const file of files) {
  const raw = readFileSync(join(ARTICLES_DIR, file), "utf8");
  try {
    const result = parseArticle(raw, file);
    parsed.push({ file, ...result });
  } catch (err) {
    if (err instanceof FrontMatterError) add(file, "front-matter", err.message);
    else throw err;
  }
}

const slugSet = new Set(parsed.map((p) => p.frontMatter.slug).filter(Boolean));

/* ------------------------------------------------------------------ *
 * Per-file rules
 * ------------------------------------------------------------------ */
for (const { file, frontMatter: fm, keyOrder, body } of parsed) {
  // `<slug>.<locale>.md` is a translation of `<slug>.md` (HANDOVER_TRANSLATION): same
  // slug and schema, its own locale, links and the two required labels in its language.
  const translation = file.match(TRANSLATION_FILE);
  const locale = translation ? translation[2] : "en";
  const labels = LABELS[locale];
  const expectedSlug = translation ? translation[1] : file.replace(/\.md$/, "");
  const prose = proseOf(body);

  /* --- front matter: required keys, parity, no extras --- */
  for (const key of REQUIRED_KEYS) {
    if (!(key in fm)) add(file, "required-key", `missing required key \`${key}\``);
  }
  for (const key of keyOrder) {
    if (!REQUIRED_KEYS.includes(key)) {
      add(file, "key-parity", `unknown key \`${key}\` — the brief fixes the schema (§5)`);
    }
  }

  /* --- fixed values --- */
  if (fm.locale !== locale) add(file, "locale", `locale must be "${locale}", got ${JSON.stringify(fm.locale)}`);
  // Publication is the repository's decision now (ADR-072; the CMS is retired).
  // A draft carries no bylines or dates; a published guide carries its dates and,
  // when a clinician has reviewed it, the reviewer's name. A reviewer may stay
  // "PENDING" on a published guide: the page then says "clinician review pending".
  const STATUSES = ["draft", "published"];
  if (!STATUSES.includes(fm.status)) {
    add(file, "status", `status must be one of ${STATUSES.join(" | ")} (§5, §9)`);
  }
  if (fm.status === "draft") {
    for (const key of ["written_by", "medically_reviewed_by"]) {
      if (fm[key] !== "PENDING") {
        add(file, "invented-byline", `${key} must be "PENDING" on a draft; never invent an author or reviewer (§5, §9). Got ${JSON.stringify(fm[key])}`);
      }
    }
    for (const key of ["date_published", "date_modified", "last_reviewed", "next_review_due"]) {
      if (fm[key] !== null) add(file, "invented-date", `${key} must be null on a draft (§5). Got ${JSON.stringify(fm[key])}`);
    }
  } else {
    const DATE = /^\d{4}-\d{2}-\d{2}$/;
    if (!DATE.test(String(fm.date_published))) add(file, "publish-date", `a published guide needs date_published as YYYY-MM-DD. Got ${JSON.stringify(fm.date_published)}`);
    if (!DATE.test(String(fm.date_modified))) add(file, "publish-date", `a published guide needs date_modified as YYYY-MM-DD. Got ${JSON.stringify(fm.date_modified)}`);
    const reviewed = fm.medically_reviewed_by !== "PENDING";
    if (reviewed && !DATE.test(String(fm.last_reviewed))) {
      add(file, "review-date", `a guide that names a reviewer needs last_reviewed as YYYY-MM-DD. Got ${JSON.stringify(fm.last_reviewed)}`);
    }
    if (!reviewed && fm.last_reviewed !== null) add(file, "review-date", `last_reviewed must be null while medically_reviewed_by is PENDING`);
    // A claim the writer could not source is a flag for the reviewer, never a sentence a
    // reader sees (CLAUDE.md: cite Tier-1/2 or flag). Drafts may carry it; a published
    // guide may not. Added 2026-10-28 for the post-launch content routines (R6.6).
    const unsourced = (body.match(/\[NEEDS SOURCE[^\]]*\]/g) ?? []).length;
    if (unsourced > 0) add(file, "needs-source", `a published guide carries ${unsourced} [NEEDS SOURCE] flag(s); source the claim or set status: draft`);
    for (const key of ["written_by", "medically_reviewed_by"]) {
      if (typeof fm[key] !== "string" || fm[key].trim() === "") add(file, "byline", `${key} must be a name or "PENDING"`);
    }
  }
  const DISCLAIMERS = ["general", "screening", "emergency", "none"];
  if (!DISCLAIMERS.includes(fm.disclaimer_type)) {
    add(file, "disclaimer-type", `disclaimer_type must be one of ${DISCLAIMERS.join(" | ")}`);
  }

  /* --- slug ↔ filename ↔ canonical_url --- */
  if (fm.slug !== expectedSlug) {
    add(file, "slug", `slug ${JSON.stringify(fm.slug)} does not match filename \`${file}\``);
  }
  if (typeof fm.canonical_url === "string") {
    const m = fm.canonical_url.match(new RegExp(`^https://femioapp\\.com/${locale}/(learn|conditions)/([a-z0-9-]+)$`));
    if (!m) {
      add(
        file,
        "canonical",
        `canonical_url must be ${SITE_ORIGIN}/${locale}/{learn|conditions}/{slug} (§5). Got ${JSON.stringify(fm.canonical_url)}`,
      );
    } else if (m[2] !== fm.slug) {
      add(file, "canonical", `canonical_url slug "${m[2]}" disagrees with slug "${fm.slug}"`);
    }
  }

  /* --- SEO metadata lengths --- */
  if (typeof fm.meta_title === "string" && (fm.meta_title.length < 30 || fm.meta_title.length > 60)) {
    add(file, "meta-length", `meta_title is ${fm.meta_title.length} chars; the brief asks for ~30–60 (§5)`);
  }
  if (
    typeof fm.meta_description === "string" &&
    (fm.meta_description.length < 120 || fm.meta_description.length > 160)
  ) {
    add(file, "meta-length", `meta_description is ${fm.meta_description.length} chars; the brief asks for ~120–160 (§5)`);
  }

  /* --- sources --- */
  const sources = Array.isArray(fm.sources) ? fm.sources : [];
  if (sources.length < 2) {
    add(file, "sources", `only ${sources.length} source(s); the brief requires at least two independent sources (§3)`);
  }
  const tiers = sources.map((s) => String(s.tier));
  if (!tiers.includes("1")) {
    add(file, "sources", `no Tier-1 source; at least one is required (§3)`);
  }
  sources.forEach((s, i) => {
    for (const field of ["title", "url", "tier"]) {
      if (!s[field]) add(file, "sources", `sources[${i}] is missing \`${field}\` (§3)`);
    }
    if (s.tier && !["1", "2"].includes(String(s.tier))) {
      add(file, "sources", `sources[${i}].tier must be "1" or "2", got ${JSON.stringify(s.tier)}`);
    }
    if (typeof s.url === "string") {
      let parsedUrl;
      try {
        parsedUrl = new URL(s.url);
      } catch {
        add(file, "sources", `sources[${i}].url is not a valid URL: ${JSON.stringify(s.url)}`);
        return;
      }
      if (parsedUrl.protocol !== "https:") {
        add(file, "sources", `sources[${i}].url must be https, got ${parsedUrl.protocol}//`);
      }
      const host = parsedUrl.hostname.replace(/^www\./, "");
      if (BANNED_SOURCE_HOSTS.some((b) => host === b || host.endsWith(`.${b}`))) {
        add(file, "sources", `sources[${i}] cites ${host}, which the brief forbids (§3: no blogs, content farms, Wikipedia, competitor apps)`);
      }
    }
  });

  /* --- internal links --- */
  const declared = Array.isArray(fm.internal_links) ? fm.internal_links : [];
  if (declared.length < 3 || declared.length > 6) {
    add(file, "internal-links", `${declared.length} internal links; the brief asks for 3–6 (§7)`);
  }
  for (const link of declared) {
    const verdict = resolveRoute(link, slugSet, locale);
    if (!verdict.ok) add(file, "internal-links", `internal_links entry \`${link}\` ${verdict.why} (§7)`);
  }
  // Every Femio link in the prose must also be declared, so the list can be trusted
  // as the thing reviewers and the importer read.
  const bodyLinks = [...body.matchAll(new RegExp(`\\]\\((/${locale}/[^)#?]*)`, "g"))].map((m) => m[1].replace(/\/$/, ""));
  for (const link of new Set(bodyLinks)) {
    const verdict = resolveRoute(link, slugSet, locale);
    if (!verdict.ok) {
      add(file, "internal-links", `body links to \`${link}\` but ${verdict.why} (§7)`);
    } else if (!declared.includes(link)) {
      add(file, "internal-links", `body links to \`${link}\` which is not listed in internal_links (§7)`);
    }
  }

  /* --- structure (§4) --- */
  const lines = body.split("\n");
  const h1s = lines.filter((l) => /^# /.test(l));
  if (h1s.length !== 1) add(file, "structure", `expected exactly one H1, found ${h1s.length} (§4)`);

  const h1Index = lines.findIndex((l) => /^# /.test(l));
  if (h1Index !== -1) {
    // Answer-first: the first thing after the H1 must be prose, not a heading.
    const after = lines.slice(h1Index + 1);
    const firstContent = after.findIndex((l) => l.trim() !== "");
    // Take the whole opening paragraph, not just its first line — authored Markdown
    // may hard-wrap, and counting one wrapped line as the answer made this rule
    // report "1 sentence" for a perfectly good four-sentence opening.
    const paragraph = [];
    for (let i = firstContent; i !== -1 && i < after.length; i++) {
      if (after[i].trim() === "") break;
      paragraph.push(after[i]);
    }
    const opening = paragraph.join(" ").trim();
    if (/^#{1,6} /.test(opening)) {
      add(file, "answer-first", `a heading follows the H1 with no answer between them; the brief requires a 2–4 sentence direct answer first (§4)`);
    } else if (opening) {
      const count = sentencesOf(proseOf(opening)).length;
      if (count < 2 || count > 5) {
        add(file, "answer-first", `opening paragraph is ${count} sentence(s); the brief asks for a 2–4 sentence answer-first opening (§4)`);
      }
    }
  }

  const isProductPage = fm.content_type === "product introduction";
  if (!isProductPage && !new RegExp(`^## ${escapeRe(labels.doctor)}\\s*$`, "im").test(body)) {
    add(file, "structure", `missing the required "## ${labels.doctor}" section (§4)`);
  }
  // The red-flag box is required where a symptom can be an emergency. `disclaimer_type`
  // is the author's own declaration that this article is in that territory, which makes
  // it a fair mechanical trigger — the judgement stays with the author, the consistency
  // is enforced here.
  if (fm.disclaimer_type === "emergency" && !new RegExp(`^>\\s*\\*\\*${escapeRe(labels.care)}\\*\\*`, "im").test(body)) {
    add(
      file,
      "red-flag",
      `disclaimer_type is "emergency" but there is no red-flag box; the brief requires a blockquote beginning \`**${labels.care}**\` (§4, §8)`,
    );
  }

  /* --- claims language (§2) --- */
  for (const sentence of sentencesOf(prose)) {
    const verb = sentence.match(CLAIM_VERBS);
    if (!verb) continue;
    if (FEMIO_SUBJECT.test(sentence)) {
      // "Femio cannot confirm, stage, or rule out a condition" is a boundary
      // statement, not a claim — negation flips the meaning entirely.
      const negated = /\b(cannot|can't|does not|doesn't|do not|don't|never|not)\b/i.test(sentence);
      if (!negated) {
        add(
          file,
          "claims",
          `"${verb[0]}" in a sentence about Femio — Femio never diagnoses, treats, prevents or acts as contraception (§2): "${sentence.slice(0, 160)}"`,
        );
      }
    }
  }
  if (/\b(?:as|for)\s+(?:a\s+)?(?:contraception|birth control)\b/i.test(prose)) {
    add(file, "claims", `frames tracking as contraception, which is never allowed (§2, §8)`);
  }

  /* --- ADR-028 health framing --- */
  for (const pattern of DECORATIVE_FRAMING) {
    const m = prose.match(pattern);
    if (m) {
      add(
        file,
        "health-framing",
        `decorative medical framing "${m[0]}" — ADR-028 renames these to clinician framing ("how we review", "clinician reviewed"). Boundary statements such as "not medical advice" and "seek urgent medical care" stay verbatim.`,
      );
    }
  }

  /* --- safety routing (§8) --- */
  const phone = prose.match(PHONE);
  if (phone) {
    add(
      file,
      "safety",
      `looks like a phone number ("${phone[0].trim()}") — Femio's crisis routing is deliberately global and number-free (§8); link to /en/help-now instead`,
    );
  }
  const crisis = prose.match(CRISIS_TOPICS);
  if (crisis && !body.includes(`/${locale}/help-now`)) {
    add(
      file,
      "safety",
      `mentions "${crisis[0]}" but never links to /en/help-now — crisis-adjacent content must route to the global crisis page (§8)`,
    );
  }
  if (locale === "en" && /\bfertile window\b/i.test(prose) && !body.includes(FERTILE_SENTENCE)) {
    add(
      file,
      "fertile-window",
      `discusses the fertile window without the approved sentence verbatim (§2): "${FERTILE_SENTENCE}"`,
    );
  }
}

/* ------------------------------------------------------------------ *
 * Cross-set rules — the ones a per-file reviewer structurally cannot do
 * ------------------------------------------------------------------ */
for (const field of ["meta_title", "meta_description", "slug", "primary_query"]) {
  const seen = new Map();
  for (const { file, frontMatter } of parsed) {
    const value = frontMatter[field];
    if (typeof value !== "string") continue;
    // A translation shares its English file's slug and competes in its own language only.
    const key = `${file.match(TRANSLATION_FILE)?.[2] ?? "en"}:${value.trim().toLowerCase()}`;
    if (!seen.has(key)) seen.set(key, []);
    seen.get(key).push(file);
  }
  for (const [value, owners] of seen) {
    if (owners.length > 1) {
      const rule = field === "primary_query" ? "cannibalisation" : "uniqueness";
      const why =
        field === "primary_query"
          ? "two articles competing for one query is keyword cannibalisation (§6, §7)"
          : `${field} must be unique across the whole set (§5)`;
      add(owners.join(", "), rule, `duplicate ${field} ${JSON.stringify(value.slice(value.indexOf(":") + 1))} — ${why}`);
    }
  }
}

/* ------------------------------------------------------------------ *
 * Optional: do the source URLs actually resolve?
 * ------------------------------------------------------------------ */
if (CHECK_URLS) {
  const urls = new Map();
  for (const { file, frontMatter } of parsed) {
    for (const s of frontMatter.sources ?? []) {
      if (typeof s.url !== "string") continue;
      if (!urls.has(s.url)) urls.set(s.url, []);
      urls.get(s.url).push(file);
    }
  }
  const entries = [...urls.entries()];
  const CONCURRENCY = 6;
  let cursor = 0;
  async function worker() {
    while (cursor < entries.length) {
      const [url, owners] = entries[cursor++];
      let status = null;
      let error = null;
      for (const method of ["HEAD", "GET"]) {
        try {
          const res = await fetch(url, {
            method,
            redirect: "follow",
            signal: AbortSignal.timeout(20000),
            headers: { "user-agent": "Mozilla/5.0 (compatible; FemioContentLint/1.0)" },
          });
          status = res.status;
          if (res.ok) break;
        } catch (e) {
          error = e.message;
        }
      }
      if (status === null) {
        add(owners.join(", "), "source-url", `could not reach ${url} (${error})`);
      } else if (status >= 400) {
        add(owners.join(", "), "source-url", `${url} returned HTTP ${status} — the brief requires a URL that resolves to the document you mean (§3)`);
      }
    }
  }
  await Promise.all(Array.from({ length: CONCURRENCY }, worker));
}

/* ------------------------------------------------------------------ *
 * Report
 * ------------------------------------------------------------------ */
if (AS_JSON) {
  console.log(JSON.stringify({ scanned: files.length, findings }, null, 2));
  process.exit(findings.length > 0 ? 1 : 0);
}

if (findings.length > 0) {
  console.error(`✗ Content guard: ${findings.length} finding(s) across ${files.length} draft(s).\n`);
  const byFile = new Map();
  for (const f of findings) {
    if (!byFile.has(f.file)) byFile.set(f.file, []);
    byFile.get(f.file).push(f);
  }
  for (const [file, items] of [...byFile.entries()].sort()) {
    console.error(`  ${file}`);
    for (const item of items) console.error(`    [${item.rule}] ${item.message}`);
    console.error("");
  }
  const counts = new Map();
  for (const f of findings) counts.set(f.rule, (counts.get(f.rule) ?? 0) + 1);
  console.error(
    "  by rule: " +
      [...counts.entries()]
        .sort((a, b) => b[1] - a[1])
        .map(([r, n]) => `${r}=${n}`)
        .join(", "),
  );
  console.error("\nThese are mechanical checks against docs/content/CODEX_AUTHORING_BRIEF.md.");
  console.error("Medical judgement is not checked here — that is the clinician's review in the CMS.");
  process.exit(1);
}

console.log(
  `✓ Content guard: ${files.length} draft(s) conform to the authoring brief` +
    (CHECK_URLS ? " (source URLs resolved)." : " (run with --check-urls to resolve sources)."),
);
