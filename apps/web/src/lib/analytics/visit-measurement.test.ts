import { describe, expect, it } from "vitest";
import { pathOnly, stripQueryAndHash } from "./visit-measurement";

// Owner decision 2026-11-24: only the path of a page may be reported, never a query or a hash.
describe("visit measurement URL", () => {
  it("drops the query string and the hash", () => {
    expect(stripQueryAndHash("https://femioapp.com/en/learn/pcos-signs?q=late+period&utm_source=x#sources")).toBe(
      "https://femioapp.com/en/learn/pcos-signs",
    );
  });

  it("keeps a clean URL as it is", () => {
    expect(stripQueryAndHash("https://femioapp.com/ar/calculators/fertile-window")).toBe(
      "https://femioapp.com/ar/calculators/fertile-window",
    );
  });

  it("never throws on a malformed URL and still strips what follows ? or #", () => {
    expect(stripQueryAndHash("/en/search?q=pcos#top")).toBe("/en/search");
  });

  it("rewrites both pageviews and events, keeping their type", () => {
    expect(pathOnly({ type: "pageview", url: "https://femioapp.com/en/search?q=pcos" })).toEqual({
      type: "pageview",
      url: "https://femioapp.com/en/search",
    });
    expect(pathOnly({ type: "event", url: "https://femioapp.com/en?a=1#b" })).toEqual({
      type: "event",
      url: "https://femioapp.com/en",
    });
  });
});
