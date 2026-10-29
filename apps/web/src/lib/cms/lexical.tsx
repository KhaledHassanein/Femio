import { Fragment, type ReactNode } from "react";
import { TriangleAlert } from "lucide-react";
import { Alert } from "@/components/ui/alert";
import type { LexicalNode, RichTextValue } from "./client";
import { isRedFlagText } from "./red-flag";

// Minimal renderer for Payload's Lexical rich text (P1.6.2). Handles the common
// nodes an article uses — paragraphs, headings, lists, links, quotes, inline
// formatting — without pulling the heavy @payloadcms/richtext-lexical package into
// the web bundle. Unknown nodes fall back to rendering their children.

const FORMAT = { bold: 1, italic: 2, strikethrough: 4, underline: 8, code: 16 } as const;

/** Plain-text extraction (for excerpts / meta descriptions). Pure + testable. */
export function lexicalToPlainText(value: RichTextValue): string {
  const walk = (node?: LexicalNode): string => {
    if (!node) return "";
    if (typeof node.text === "string") return node.text;
    return (node.children ?? []).map(walk).join(node.type === "paragraph" ? "" : "");
  };
  const parts = (value?.root?.children ?? []).map((n) => walk(n).trim()).filter(Boolean);
  return parts.join(" ");
}

/** The text of a node and everything under it, for deciding what kind of quote this is. */
function nodeText(node: LexicalNode): string {
  if (typeof node.text === "string") return node.text;
  return (node.children ?? []).map(nodeText).join("");
}

function textWithFormat(node: LexicalNode, key: number): ReactNode {
  let el: ReactNode = node.text ?? "";
  const f = node.format ?? 0;
  if (f & FORMAT.code) el = <code>{el}</code>;
  if (f & FORMAT.bold) el = <strong>{el}</strong>;
  if (f & FORMAT.italic) el = <em>{el}</em>;
  if (f & FORMAT.underline) el = <u>{el}</u>;
  if (f & FORMAT.strikethrough) el = <s>{el}</s>;
  return <Fragment key={key}>{el}</Fragment>;
}

function children(node: LexicalNode): ReactNode {
  return (node.children ?? []).map((child, i) => renderNode(child, i));
}

function renderNode(node: LexicalNode, key: number): ReactNode {
  switch (node.type) {
    case "text":
      return textWithFormat(node, key);
    case "linebreak":
      return <br key={key} />;
    case "paragraph":
      return (
        <p key={key} className="leading-relaxed text-text">
          {children(node)}
        </p>
      );
    case "heading": {
      const tag = (node.tag as "h1" | "h2" | "h3" | "h4" | "h5" | "h6") ?? "h2";
      const cls =
        tag === "h2"
          ? "font-display text-xl text-text mt-6"
          : tag === "h3"
            ? "font-display text-lg text-text mt-5"
            : "font-semibold text-text mt-4";
      const Tag = tag;
      return (
        <Tag key={key} className={cls}>
          {children(node)}
        </Tag>
      );
    }
    case "quote":
      // A quote that opens with the red-flag prefix ("Seek care now:") is the article's
      // warning-signs box, not a pull quote: danger tokens plus an icon so the meaning
      // never rides on colour alone (docs/12). `role="note"` because it is static page
      // content, not a live announcement (the Alert default, role="alert", would be
      // read out on load, once per box).
      if (isRedFlagText(nodeText(node))) {
        return (
          <Alert
            key={key}
            variant="danger"
            role="note"
            icon={<TriangleAlert className="size-5" />}
            data-testid="red-flag-box"
          >
            <p className="leading-relaxed">{children(node)}</p>
          </Alert>
        );
      }
      return (
        <blockquote key={key} className="border-s-2 border-border ps-4 text-text-muted">
          {children(node)}
        </blockquote>
      );
    case "list": {
      const ordered = node.tag === "ol" || node.listType === "number";
      const Tag = ordered ? "ol" : "ul";
      return (
        <Tag key={key} className={ordered ? "list-decimal ps-6" : "list-disc ps-6"}>
          {children(node)}
        </Tag>
      );
    }
    case "listitem":
      return (
        <li key={key} className="text-text">
          {children(node)}
        </li>
      );
    case "link": {
      const href = node.fields?.url ?? node.url ?? "#";
      const external = /^https?:\/\//i.test(href);
      return (
        <a
          key={key}
          href={href}
          className="text-text-link underline"
          {...(external ? { rel: "noreferrer", target: "_blank" } : {})}
        >
          {children(node)}
        </a>
      );
    }
    default:
      // Unknown/root-level wrappers → render children inline.
      return <Fragment key={key}>{children(node)}</Fragment>;
  }
}

export function RichText({ content }: { content: RichTextValue }) {
  return <RichTextNodes nodes={content?.root?.children ?? []} />;
}

/** The same renderer over a slice of top-level nodes, for a body rendered in two parts. */
export function RichTextNodes({ nodes }: { nodes: LexicalNode[] }) {
  if (nodes.length === 0) return null;
  return <div className="flex flex-col gap-3">{nodes.map((n, i) => renderNode(n, i))}</div>;
}

/**
 * Splits a body after its first H2 section, for the mid-article ad placement (R6.8,
 * 02_MONETIZATION.md §1.1): everything up to the second H2 is the first part, the
 * second H2 onwards is the rest. A body with fewer than two H2s is one part and an
 * empty rest, so a short article gets no mid unit. Pure; the renderer above draws
 * each part, and the split never lands inside a list, a quote or a warning box
 * because it only ever falls between top-level nodes, right before a heading.
 */
export function splitAfterFirstSection(value: RichTextValue): { head: LexicalNode[]; rest: LexicalNode[] } {
  const nodes = value?.root?.children ?? [];
  let seen = 0;
  for (let i = 0; i < nodes.length; i++) {
    const node = nodes[i];
    if (node?.type === "heading" && (node.tag ?? "h2") === "h2") {
      seen += 1;
      if (seen === 2) return { head: nodes.slice(0, i), rest: nodes.slice(i) };
    }
  }
  return { head: nodes, rest: [] };
}
