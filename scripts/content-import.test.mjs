#!/usr/bin/env node
/**
 * Tests for the Markdown → Lexical converter and the importer's refusal paths (P1.9.2).
 *
 * Two things are being protected here. The converter must not lose text — an importer
 * that silently drops a red-flag box or a citation link produces a page that looks
 * finished and is not, and nobody re-reads sixty articles to notice. And the importer
 * must actually refuse the input it claims to refuse; validation that has never been
 * observed rejecting anything is indistinguishable from no validation.
 *
 * The importer cases run in dry-run mode, which completes before Payload is imported,
 * so no database is involved.
 *
 * Run: node scripts/content-import.test.mjs
 */
import { mkdtempSync, writeFileSync, rmSync, readFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { execFileSync } from "node:child_process";
import { markdownToLexical, MarkdownError } from "./lib/markdown-to-lexical.mjs";

let failed = 0;
const ok = (name) => console.log(`✓ ${name}`);
const bad = (name, detail) => {
  failed++;
  console.error(`✗ ${name}`);
  console.error(`    ${detail}`);
};

function check(name, fn) {
  try {
    const problem = fn();
    if (problem) bad(name, problem);
    else ok(name);
  } catch (err) {
    bad(name, `threw: ${err.message}`);
  }
}

/* ------------------------------------------------------------------ *
 * Converter — structure
 * ------------------------------------------------------------------ */
const flat = (node, out = []) => {
  out.push(node);
  (node.children ?? []).forEach((c) => flat(c, out));
  return out;
};
const typesIn = (root) => flat(root).map((n) => n.type);
const textOf = (root) =>
  flat(root)
    .filter((n) => typeof n.text === "string")
    .map((n) => n.text)
    .join("");

check("H1 is lifted out of the body, not duplicated in it", () => {
  const { h1, root } = markdownToLexical("# The Title\n\nSome words here.");
  if (h1 !== "The Title") return `h1 was ${JSON.stringify(h1)}`;
  if (typesIn(root).includes("heading")) return "the H1 was also left in the body";
  return null;
});

check("headings keep their level", () => {
  const { root } = markdownToLexical("## Two\n\n### Three\n\nBody text.");
  const tags = flat(root).filter((n) => n.type === "heading").map((n) => n.tag);
  return JSON.stringify(tags) === '["h2","h3"]' ? null : `got ${JSON.stringify(tags)}`;
});

check("wrapped lines join into one paragraph", () => {
  const { root } = markdownToLexical("A sentence that\nwraps across lines.");
  const paras = flat(root).filter((n) => n.type === "paragraph");
  if (paras.length !== 1) return `expected 1 paragraph, got ${paras.length}`;
  return textOf(root) === "A sentence that wraps across lines." ? null : `got ${JSON.stringify(textOf(root))}`;
});

check("blank line separates paragraphs", () => {
  const { root } = markdownToLexical("First para.\n\nSecond para.");
  const paras = flat(root).filter((n) => n.type === "paragraph");
  return paras.length === 2 ? null : `expected 2 paragraphs, got ${paras.length}`;
});

check("bullet list becomes one list with its items", () => {
  const { root } = markdownToLexical("- one\n- two\n- three");
  const lists = flat(root).filter((n) => n.type === "list");
  const items = flat(root).filter((n) => n.type === "listitem");
  if (lists.length !== 1) return `expected 1 list, got ${lists.length}`;
  if (lists[0].tag !== "ul") return `expected ul, got ${lists[0].tag}`;
  return items.length === 3 ? null : `expected 3 items, got ${items.length}`;
});

check("numbered list is ordered", () => {
  const { root } = markdownToLexical("1. one\n2. two");
  const list = flat(root).find((n) => n.type === "list");
  return list?.tag === "ol" && list.listType === "number" ? null : `got ${JSON.stringify(list?.tag)}`;
});

check("red-flag blockquote survives as a quote node", () => {
  const { root } = markdownToLexical("> **Seek care now:** Heavy bleeding\n> with fainting.");
  const quotes = flat(root).filter((n) => n.type === "quote");
  if (quotes.length !== 1) return `expected 1 quote, got ${quotes.length}`;
  if (!textOf(root).includes("Seek care now:")) return "the red-flag label was lost";
  return textOf(root).includes("fainting") ? null : "the continuation line was lost";
});

check("links keep their href and label", () => {
  const { root } = markdownToLexical("See the [learning library](/en/learn) for more.");
  const link = flat(root).find((n) => n.type === "link");
  if (!link) return "no link node produced";
  if (link.fields.url !== "/en/learn") return `href was ${link.fields.url}`;
  return textOf(root) === "See the learning library for more." ? null : `text was ${JSON.stringify(textOf(root))}`;
});

check("external links open in a new tab, internal ones do not", () => {
  const ext = flat(markdownToLexical("[NICE](https://www.nice.org.uk/x)").root).find((n) => n.type === "link");
  const int = flat(markdownToLexical("[learn](/en/learn)").root).find((n) => n.type === "link");
  if (ext.fields.newTab !== true) return "external link did not set newTab";
  return int.fields.newTab === false ? null : "internal link set newTab";
});

check("bold text carries the bold format bit", () => {
  const { root } = markdownToLexical("This is **important** text.");
  const boldNode = flat(root).find((n) => n.text === "important");
  return boldNode?.format === 1 ? null : `format was ${boldNode?.format}`;
});

/* ------------------------------------------------------------------ *
 * Converter — refusals
 * ------------------------------------------------------------------ */
const refuses = (name, markdown, expect) =>
  check(name, () => {
    try {
      markdownToLexical(markdown);
      return "converted without complaint — it should have refused";
    } catch (err) {
      if (!(err instanceof MarkdownError)) return `threw ${err.name}, expected MarkdownError`;
      return err.message.includes(expect) ? null : `message was ${JSON.stringify(err.message)}`;
    }
  });

refuses("refuses tables rather than dropping them", "| a | b |\n| - | - |", "tables");
refuses("refuses code fences", "```js\ncode\n```", "code fences");
refuses("refuses images", "![alt text](/x.png)", "images");
refuses("refuses raw HTML", "<div>hello</div>", "raw HTML");
refuses("refuses a second H1", "# One\n\n# Two", "more than one H1");
refuses("refuses an empty document", "\n\n", "empty document");

/* ------------------------------------------------------------------ *
 * Importer — refusal paths (dry run; no database)
 * ------------------------------------------------------------------ */
const REAL = "docs/content/articles/pcos.md";
const realDraft = readFileSync(REAL, "utf8");

function runImporter(files) {
  const dir = mkdtempSync(join(tmpdir(), "femio-import-"));
  try {
    for (const [name, content] of Object.entries(files)) {
      writeFileSync(join(dir, name), content, "utf8");
    }
    try {
      const out = execFileSync(
        "pnpm",
        ["--filter", "cms", "exec", "payload", "run", "./scripts/import-articles.mjs", "--", "--skip-lint", `--dir=${dir}`],
        { encoding: "utf8", cwd: process.cwd(), shell: true },
      );
      return { code: 0, out };
    } catch (err) {
      return { code: err.status ?? 1, out: `${err.stdout ?? ""}${err.stderr ?? ""}` };
    }
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
}

const importerCases = [
  {
    name: "importer accepts a real draft (dry run)",
    files: { "pcos.md": realDraft },
    expectCode: 0,
    expect: "1 draft(s) validated",
  },
  {
    name: "importer refuses an invented byline",
    files: { "pcos.md": realDraft.replace('written_by: "PENDING"', 'written_by: "Dr Jane Smith"') },
    expectCode: 1,
    expect: "will not create a byline",
  },
  {
    name: "importer refuses status other than draft",
    files: { "pcos.md": realDraft.replace('status: "draft"', 'status: "published"') },
    expectCode: 1,
    expect: "only drafts may be imported",
  },
  {
    name: "importer refuses a slug/filename mismatch",
    files: { "pcos.md": realDraft.replace('slug: "pcos"', 'slug: "pcos-renamed"') },
    expectCode: 1,
    expect: "slug does not match filename",
  },
  {
    name: "importer refuses a single source",
    files: {
      "pcos.md": realDraft.replace(/^sources:[\s\S]*?^internal_links:/m, [
        "sources:",
        '  - title: "NICE"',
        '    url: "https://www.nice.org.uk/x"',
        '    tier: "1"',
        "internal_links:",
      ].join("\n")),
    },
    expectCode: 1,
    expect: "at least two are required",
  },
  {
    name: "importer refuses unreadable front matter",
    files: { "pcos.md": realDraft.replace('locale: "en"', "locale: en") },
    expectCode: 1,
    expect: "unquoted value",
  },
  {
    name: "importer refuses a body it cannot convert faithfully",
    files: { "pcos.md": `${realDraft}\n\n| col | col |\n| --- | --- |\n` },
    expectCode: 1,
    expect: "tables are not supported",
  },
  {
    name: "importer refuses when the H1 disagrees with the title",
    files: { "pcos.md": realDraft.replace(/^# .*$/m, "# A Completely Different Heading") },
    expectCode: 1,
    expect: "differs from `title`",
  },
  {
    name: "importer refuses an empty directory rather than reporting success",
    files: {},
    expectCode: 1,
    expect: "Refusing to report success on nothing",
  },
];

for (const testCase of importerCases) {
  const { code, out } = runImporter(testCase.files);
  if (code !== testCase.expectCode) {
    bad(testCase.name, `exit ${code}, expected ${testCase.expectCode}. Output:\n${out.slice(-600)}`);
  } else if (!out.includes(testCase.expect)) {
    bad(testCase.name, `output did not mention ${JSON.stringify(testCase.expect)}. Output:\n${out.slice(-600)}`);
  } else {
    ok(testCase.name);
  }
}

console.log("");
if (failed > 0) {
  console.error(`✗ content-import self-test: ${failed} case(s) failed.`);
  process.exit(1);
}
console.log("✓ content-import self-test: converter preserves content, importer refuses what it should.");
