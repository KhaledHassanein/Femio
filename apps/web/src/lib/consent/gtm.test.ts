import { describe, expect, it } from "vitest";
import { CONSENT_DEFAULT_SNIPPET } from "./consent-default";
import { GTM_HOST, gtmInlineScript, gtmNoScriptSrc, isGtmId } from "./gtm";

describe("Tag Manager loader (ADR-075)", () => {
  it("accepts only a container id", () => {
    expect(isGtmId("GTM-ABC1234")).toBe(true);
    expect(isGtmId("G-ABC1234")).toBe(false); // a GA4 measurement id must ride inside the container
    expect(isGtmId("")).toBe(false);
    expect(isGtmId(undefined)).toBe(false);
    expect(isGtmId("GTM-abc")).toBe(false);
    expect(isGtmId("GTM-ABC1234'); alert(1); ('")).toBe(false);
  });

  it("puts the consent defaults before the loader, in the same script", () => {
    const script = gtmInlineScript("GTM-TEST001");
    expect(script.startsWith(CONSENT_DEFAULT_SNIPPET)).toBe(true);
    expect(script.indexOf("gtag('consent','default'")).toBeLessThan(script.indexOf("gtm.js?id="));
    expect(script).toContain(`https://${GTM_HOST}/gtm.js?id=`);
    expect(script).toContain("'GTM-TEST001'");
  });

  it("refuses to build markup for a malformed id", () => {
    expect(() => gtmInlineScript("not-an-id")).toThrow();
    expect(() => gtmNoScriptSrc("not-an-id")).toThrow();
    expect(gtmNoScriptSrc("GTM-TEST001")).toBe(`https://${GTM_HOST}/ns.html?id=GTM-TEST001`);
  });

  it("loads nothing but the container host", () => {
    const script = gtmInlineScript("GTM-TEST001");
    const hosts = [...script.matchAll(/https?:\/\/([a-z0-9.-]+)/gi)].map((m) => m[1]);
    expect(new Set(hosts)).toEqual(new Set([GTM_HOST]));
  });
});
