/**
 * Markdown → Payload Lexical converter for the article importer (P1.9.2).
 *
 * Scope is deliberately the exact subset the authoring brief produces — headings,
 * paragraphs, bullet and numbered lists, blockquotes, links, and inline emphasis.
 * Anything else (tables, images, code fences, raw HTML) **throws** rather than being
 * dropped, because the failure mode that matters here is silent loss: an importer
 * that quietly discards a red-flag box or a citation link produces a page that looks
 * complete and is not, and nobody re-reads 60 articles to notice. Refusing is how the
 * brief's format stays a specification.
 *
 * The node shapes match what `apps/web/src/lib/cms/lexical.tsx` renders, so what the
 * importer writes is what a reader sees.
 */

export class MarkdownError extends Error {
  constructor(message, line) {
    super(line == null ? message : `${message} (body line ${line})`);
    this.name = "MarkdownError";
    this.line = line;
  }
}

const textNode = (text, format = 0) => ({
  type: "text",
  text,
  format,
  detail: 0,
  mode: "normal",
  style: "",
  version: 1,
});

const FORMAT = { bold: 1, italic: 2, code: 16 };

/**
 * Inline parser: `**bold**`, `*italic*`, `` `code` `` and `[label](href)`.
 * Emphasis inside a link label is supported; nesting beyond that is not, and the
 * brief's copy does not use it.
 */
function parseInline(text, lineNo) {
  if (/!\[/.test(text)) {
    throw new MarkdownError("images are not supported by the importer", lineNo);
  }
  if (/<[a-zA-Z][^>]*>/.test(text)) {
    throw new MarkdownError(`raw HTML is not supported by the importer: ${text.trim().slice(0, 60)}`, lineNo);
  }

  const nodes = [];
  // Links first: their label is then parsed for emphasis on its own.
  const linkPattern = /\[([^\]]+)\]\(([^)\s]+)\)/g;
  let cursor = 0;
  let match;
  while ((match = linkPattern.exec(text)) !== null) {
    if (match.index > cursor) nodes.push(...parseEmphasis(text.slice(cursor, match.index), lineNo));
    const [, label, url] = match;
    nodes.push({
      type: "link",
      fields: { linkType: "custom", url, newTab: /^https?:\/\//i.test(url) },
      children: parseEmphasis(label, lineNo),
      direction: "ltr",
      format: "",
      indent: 0,
      version: 3,
    });
    cursor = match.index + match[0].length;
  }
  if (cursor < text.length) nodes.push(...parseEmphasis(text.slice(cursor), lineNo));
  return nodes.length > 0 ? nodes : [textNode("")];
}

function parseEmphasis(text, lineNo) {
  const nodes = [];
  const pattern = /\*\*([^*]+)\*\*|(?<![*\w])\*([^*\n]+)\*(?!\*)|`([^`]+)`/g;
  let cursor = 0;
  let match;
  while ((match = pattern.exec(text)) !== null) {
    if (match.index > cursor) nodes.push(textNode(text.slice(cursor, match.index)));
    if (match[1] !== undefined) nodes.push(textNode(match[1], FORMAT.bold));
    else if (match[2] !== undefined) nodes.push(textNode(match[2], FORMAT.italic));
    else nodes.push(textNode(match[3], FORMAT.code));
    cursor = match.index + match[0].length;
  }
  if (cursor < text.length) nodes.push(textNode(text.slice(cursor)));
  if (nodes.some((n) => typeof n.text === "string" && n.text.includes("**"))) {
    throw new MarkdownError(`unbalanced bold markers: ${text.trim().slice(0, 60)}`, lineNo);
  }
  return nodes;
}

const block = (extra) => ({ direction: "ltr", format: "", indent: 0, version: 1, ...extra });

/**
 * Convert a Markdown body to `{ h1, root }`.
 * The H1 is returned separately, not embedded: the CMS holds the title in its own
 * field and the page renders it, so leaving it in the body would ship two H1s.
 */
export function markdownToLexical(markdown, { filename = "<input>" } = {}) {
  const source = markdown.replace(/\r\n/g, "\n").replace(/<!--[\s\S]*?-->/g, "");
  const lines = source.split("\n");
  const children = [];
  let h1 = null;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const lineNo = i + 1;
    const trimmed = line.trim();
    if (trimmed === "") continue;

    if (trimmed.startsWith("```") || trimmed.startsWith("~~~")) {
      throw new MarkdownError(`${filename}: code fences are not supported by the importer`, lineNo);
    }
    if (trimmed.startsWith("|")) {
      throw new MarkdownError(`${filename}: tables are not supported by the importer`, lineNo);
    }
    if (/^(-{3,}|\*{3,}|_{3,})$/.test(trimmed)) {
      throw new MarkdownError(`${filename}: horizontal rules are not supported by the importer`, lineNo);
    }

    // Heading
    const heading = trimmed.match(/^(#{1,6})\s+(.*)$/);
    if (heading) {
      const level = heading[1].length;
      const content = heading[2].trim();
      if (level === 1) {
        if (h1 !== null) {
          throw new MarkdownError(`${filename}: more than one H1 in the body`, lineNo);
        }
        h1 = content;
        continue;
      }
      children.push(
        block({ type: "heading", tag: `h${level}`, children: parseInline(content, lineNo) }),
      );
      continue;
    }

    // Blockquote — consecutive `> ` lines form one quote.
    if (/^>\s?/.test(trimmed)) {
      const parts = [];
      while (i < lines.length && /^>\s?/.test(lines[i].trim())) {
        parts.push(lines[i].trim().replace(/^>\s?/, ""));
        i++;
      }
      i--;
      children.push(
        block({ type: "quote", children: parseInline(parts.join(" ").trim(), lineNo) }),
      );
      continue;
    }

    // Lists — consecutive items of the same kind form one list.
    const bullet = trimmed.match(/^[-*]\s+(.*)$/);
    const ordered = trimmed.match(/^(\d+)\.\s+(.*)$/);
    if (bullet || ordered) {
      const isOrdered = Boolean(ordered);
      const items = [];
      while (i < lines.length) {
        const t = lines[i].trim();
        if (t === "") {
          // A blank line ends the list unless another item follows immediately.
          const next = lines[i + 1]?.trim() ?? "";
          const continues = isOrdered ? /^\d+\.\s+/.test(next) : /^[-*]\s+/.test(next);
          if (!continues) break;
          i++;
          continue;
        }
        const m = isOrdered ? t.match(/^(\d+)\.\s+(.*)$/) : t.match(/^[-*]\s+(.*)$/);
        if (!m) break;
        const content = isOrdered ? m[2] : m[1];
        items.push(
          block({
            type: "listitem",
            value: items.length + 1,
            checked: undefined,
            children: parseInline(content, i + 1),
          }),
        );
        i++;
      }
      i--;
      children.push(
        block({
          type: "list",
          listType: isOrdered ? "number" : "bullet",
          tag: isOrdered ? "ol" : "ul",
          start: 1,
          children: items,
        }),
      );
      continue;
    }

    // Paragraph — consecutive plain lines are one paragraph (authored Markdown wraps).
    const parts = [];
    while (i < lines.length) {
      const t = lines[i].trim();
      if (
        t === "" ||
        /^#{1,6}\s/.test(t) ||
        /^>\s?/.test(t) ||
        /^[-*]\s+/.test(t) ||
        /^\d+\.\s+/.test(t) ||
        t.startsWith("|") ||
        t.startsWith("```")
      ) {
        break;
      }
      parts.push(t);
      i++;
    }
    i--;
    children.push(
      block({ type: "paragraph", textFormat: 0, children: parseInline(parts.join(" "), lineNo) }),
    );
  }

  if (children.length === 0) {
    throw new MarkdownError(`${filename}: body converted to an empty document`);
  }

  return {
    h1,
    root: block({ type: "root", children }),
  };
}
