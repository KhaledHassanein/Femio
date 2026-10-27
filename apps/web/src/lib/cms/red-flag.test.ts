import { describe, expect, it } from "vitest";
import { renderToStaticMarkup } from "react-dom/server";
import { createElement } from "react";
import articles from "@/content/snapshot/articles.json";
import conditions from "@/content/snapshot/conditions.json";
import { isRedFlagText } from "./red-flag";
import { RichText } from "./lexical";
import type { LexicalNode } from "./client";

const text = (value: string, format = 0): LexicalNode => ({ type: "text", text: value, format });
const quote = (...kids: LexicalNode[]): LexicalNode => ({ type: "quote", children: kids });
const render = (node: LexicalNode) =>
  renderToStaticMarkup(createElement(RichText, { content: { root: { children: [node] } } }));

describe("isRedFlagText", () => {
  it("matches the English prefix, with or without leading space, any case", () => {
    expect(isRedFlagText("Seek care now: go to the nearest emergency department")).toBe(true);
    expect(isRedFlagText("  seek care now: call")).toBe(true);
  });
  it("needs the colon, so an ordinary sentence is not a box", () => {
    expect(isRedFlagText("Seek care now or later")).toBe(false);
    expect(isRedFlagText("Most people do not need to seek care now: it is normal")).toBe(false);
  });
  it("matches the provisional Arabic, French and Spanish openings", () => {
    expect(isRedFlagText("اطلبي الرعاية الآن: توجّهي إلى الطوارئ")).toBe(true);
    expect(isRedFlagText("Consultez sans attendre : rendez-vous aux urgences")).toBe(true);
    expect(isRedFlagText("Busca atención ahora: acude a urgencias")).toBe(true);
  });
});

describe("RichText quotes", () => {
  it("renders a red-flag quote as the danger alert with an icon, keeping the bold prefix", () => {
    const html = render(quote(text("Seek care now:", 1), text(" Call emergency services.")));
    expect(html).toContain('data-testid="red-flag-box"');
    expect(html).toContain("bg-danger-soft");
    expect(html).toContain('role="note"');
    expect(html).toContain("<svg");
    expect(html).toContain("<strong>Seek care now:</strong>");
    expect(html).not.toContain("<blockquote");
  });
  it("leaves any other quote as a plain blockquote", () => {
    const html = render(quote(text("A pull quote.")));
    expect(html).toContain("<blockquote");
    expect(html).not.toContain("red-flag-box");
  });
});

describe("the published snapshot", () => {
  const docs = [...articles.en, ...conditions.en];
  const quotes: string[] = [];
  const walk = (n: LexicalNode) => {
    if (n.type === "quote") {
      const flat = (x: LexicalNode): string =>
        typeof x.text === "string" ? x.text : (x.children ?? []).map(flat).join("");
      quotes.push(flat(n));
    }
    (n.children ?? []).forEach(walk);
  };
  for (const d of docs) walk((d.body as unknown as { root: LexicalNode }).root);

  it("has red-flag boxes to render", () => {
    expect(quotes.length).toBeGreaterThan(50);
  });
  it("opens every quote with a recognised red-flag prefix (a new prefix must be added to red-flag.ts)", () => {
    const missed = quotes.filter((q) => !isRedFlagText(q));
    expect(missed).toEqual([]);
  });
});
