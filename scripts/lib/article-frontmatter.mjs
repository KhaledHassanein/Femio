/**
 * Shared front-matter reader for Femio's authored article drafts
 * (`docs/content/articles/*.md`, written against docs/content/CODEX_AUTHORING_BRIEF.md §5).
 *
 * Used by BOTH `scripts/content-lint.mjs` (P1.9.1) and the Markdown → Payload
 * importer (P1.9.2), on purpose: if the linter and the importer disagreed about
 * what a file means, a draft could pass review and then import as something else.
 * One parser, one definition of "valid".
 *
 * This is deliberately NOT a general YAML parser. The brief fixes a small, regular
 * schema — double-quoted scalars, `null`/booleans bare, string lists, and lists of
 * flat objects (`sources`) — and a strict reader over that subset is safer here than
 * a permissive one: a general parser would happily accept a typo'd shape and hand
 * back something subtly wrong, whereas this throws with the line number. Anything
 * outside the subset (block scalars, single quotes, nesting, tabs) is an error, not
 * a silent reinterpretation. That refusal is the feature — it is what lets the brief's
 * schema act as a specification rather than an aspiration.
 */

/** Keys the brief requires in every article, in its documented order (§5). */
export const REQUIRED_KEYS = [
  "title",
  "slug",
  "locale",
  "status",
  "content_type",
  "search_intent",
  "primary_query",
  "secondary_topics",
  "excerpt",
  "meta_title",
  "meta_description",
  "canonical_url",
  "robots_while_draft",
  "robots_when_published",
  "open_graph_title",
  "open_graph_description",
  "open_graph_image",
  "open_graph_image_alt",
  "written_by",
  "medically_reviewed_by",
  "date_published",
  "date_modified",
  "last_reviewed",
  "next_review_due",
  "reading_level_ok",
  "reading_level_method",
  "disclaimer_type",
  "structured_data_required",
  "sources",
  "internal_links",
];

/** Keys whose value must be a list of strings. */
export const LIST_KEYS = new Set([
  "secondary_topics",
  "structured_data_required",
  "internal_links",
]);

/** Keys whose value must be a list of flat objects. */
export const OBJECT_LIST_KEYS = new Set(["sources"]);

export class FrontMatterError extends Error {
  constructor(message, line) {
    super(line == null ? message : `${message} (line ${line})`);
    this.name = "FrontMatterError";
    this.line = line;
  }
}

/** Parse one `key: value` scalar from the restricted subset. */
function parseScalar(raw, lineNo) {
  const value = raw.trim();
  if (value === "null") return null;
  if (value === "true") return true;
  if (value === "false") return false;
  if (value.startsWith('"')) {
    if (!value.endsWith('"') || value.length < 2) {
      throw new FrontMatterError(`unterminated double-quoted string: ${value}`, lineNo);
    }
    // The brief's copy contains no escape sequences; reject them rather than
    // guess at semantics we have never had to define.
    const inner = value.slice(1, -1);
    if (inner.includes('"')) {
      throw new FrontMatterError(
        `embedded double quote is not supported in this subset: ${value}`,
        lineNo,
      );
    }
    return inner;
  }
  if (value === "") {
    throw new FrontMatterError("empty value; use null, or quote an empty string", lineNo);
  }
  if (value.startsWith("'")) {
    throw new FrontMatterError(
      `single-quoted strings are not part of this subset; use double quotes`,
      lineNo,
    );
  }
  if (value === "|" || value === ">" || value.startsWith("|") || value.startsWith(">")) {
    throw new FrontMatterError(`block scalars are not part of this subset`, lineNo);
  }
  throw new FrontMatterError(
    `unquoted value \`${value}\`; strings must be double-quoted (only null/true/false may be bare)`,
    lineNo,
  );
}

/**
 * Split a file into `{ frontMatter, body, bodyStartLine }`.
 * Throws FrontMatterError on anything it cannot read exactly.
 */
export function parseArticle(text, filename = "<input>") {
  const normalized = text.replace(/\r\n/g, "\n");
  const lines = normalized.split("\n");

  if (lines[0] !== "---") {
    throw new FrontMatterError(`${filename}: file must open with a \`---\` front-matter fence`, 1);
  }
  const closing = lines.indexOf("---", 1);
  if (closing === -1) {
    throw new FrontMatterError(`${filename}: front matter is never closed by \`---\``, 1);
  }

  const fm = {};
  const keyOrder = [];
  let currentKey = null;
  let currentKind = null; // "list" | "objectList"

  for (let i = 1; i < closing; i++) {
    const line = lines[i];
    const lineNo = i + 1;
    if (line.trim() === "") continue;
    if (line.includes("\t")) {
      throw new FrontMatterError(`${filename}: tab character in front matter`, lineNo);
    }

    // A list item belonging to the key most recently opened.
    if (/^ {2}- /.test(line)) {
      if (!currentKey) {
        throw new FrontMatterError(`${filename}: list item before any key`, lineNo);
      }
      const item = line.slice(4);
      if (currentKind === "objectList") {
        const m = item.match(/^([a-z_][a-z0-9_]*): (.*)$/);
        if (!m) {
          throw new FrontMatterError(
            `${filename}: \`${currentKey}\` expects \`- key: "value"\` entries, got: ${item.trim()}`,
            lineNo,
          );
        }
        fm[currentKey].push({ [m[1]]: parseScalar(m[2], lineNo), __line: lineNo });
      } else {
        fm[currentKey].push(parseScalar(item, lineNo));
      }
      continue;
    }

    // A continuation field of the current object-list entry.
    if (/^ {4}[a-z_]/.test(line)) {
      if (currentKind !== "objectList" || fm[currentKey].length === 0) {
        throw new FrontMatterError(`${filename}: unexpected indented field`, lineNo);
      }
      const m = line.trim().match(/^([a-z_][a-z0-9_]*): (.*)$/);
      if (!m) {
        throw new FrontMatterError(`${filename}: cannot read indented field: ${line.trim()}`, lineNo);
      }
      fm[currentKey][fm[currentKey].length - 1][m[1]] = parseScalar(m[2], lineNo);
      continue;
    }

    // A top-level key.
    const m = line.match(/^([a-z_][a-z0-9_]*):(.*)$/);
    if (!m) {
      throw new FrontMatterError(`${filename}: cannot read front-matter line: ${line}`, lineNo);
    }
    const [, key, rest] = m;
    if (Object.prototype.hasOwnProperty.call(fm, key)) {
      throw new FrontMatterError(`${filename}: duplicate key \`${key}\``, lineNo);
    }
    keyOrder.push(key);
    currentKey = key;

    if (rest.trim() === "") {
      currentKind = OBJECT_LIST_KEYS.has(key) ? "objectList" : "list";
      fm[key] = [];
    } else {
      currentKind = null;
      fm[key] = parseScalar(rest, lineNo);
    }
  }

  // Strip the bookkeeping we used for error messages, keeping it accessible.
  const sourceLines = {};
  for (const key of Object.keys(fm)) {
    if (Array.isArray(fm[key])) {
      for (const entry of fm[key]) {
        if (entry && typeof entry === "object" && "__line" in entry) {
          sourceLines[`${key}[${fm[key].indexOf(entry)}]`] = entry.__line;
          delete entry.__line;
        }
      }
    }
  }

  return {
    frontMatter: fm,
    keyOrder,
    body: lines.slice(closing + 1).join("\n"),
    bodyStartLine: closing + 2,
    sourceLines,
  };
}
