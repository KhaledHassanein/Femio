import { describe, expect, it } from "vitest";
import { isApprovedDirectoryUrl } from "./directory";

describe("isApprovedDirectoryUrl", () => {
  it("accepts the canonical Find A Helpline HTTPS URL", () => {
    expect(isApprovedDirectoryUrl("https://findahelpline.com/")).toBe(true);
    expect(isApprovedDirectoryUrl("https://findahelpline.com/topics/eating-body-image")).toBe(true);
  });

  it("rejects non-HTTPS", () => {
    expect(isApprovedDirectoryUrl("http://findahelpline.com/")).toBe(false);
  });

  it("rejects any other host (including subdomains and look-alikes)", () => {
    expect(isApprovedDirectoryUrl("https://www.findahelpline.com/")).toBe(false);
    expect(isApprovedDirectoryUrl("https://evil.com/")).toBe(false);
    expect(isApprovedDirectoryUrl("https://findahelpline.com.evil.com/")).toBe(false);
  });

  it("rejects URLs carrying a query string or fragment (could leak identifiers)", () => {
    expect(isApprovedDirectoryUrl("https://findahelpline.com/?ref=femio&uid=123")).toBe(false);
    expect(isApprovedDirectoryUrl("https://findahelpline.com/#user")).toBe(false);
  });

  it("rejects malformed input", () => {
    expect(isApprovedDirectoryUrl("not a url")).toBe(false);
    expect(isApprovedDirectoryUrl("")).toBe(false);
  });
});
