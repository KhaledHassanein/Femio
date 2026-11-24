/**
 * The AdSense loader must set the Consent Mode defaults before AdSense can run
 * (ADR-080): one inline script, defaults first, loader second, loaded once per page.
 */
import { describe, expect, it } from "vitest";
import { adsenseScriptSrc } from "./adsense";
import { ADSENSE_LOADER_ID, adsenseLoaderSnippet } from "./adsense-script";

const CLIENT = "ca-pub-1234567890123456";

describe("adsenseLoaderSnippet", () => {
  it("sets every consent default before it adds the AdSense script", () => {
    const s = adsenseLoaderSnippet(CLIENT);
    const defaults = s.indexOf("gtag('consent','default'");
    const loader = s.indexOf("document.createElement('script')");
    expect(defaults).toBeGreaterThanOrEqual(0);
    expect(loader).toBeGreaterThan(defaults);
    expect(s).toContain('"ad_storage":"denied"');
  });

  it("loads the script once, async, from the AdSense host with this client", () => {
    const s = adsenseLoaderSnippet(CLIENT);
    expect(s).toContain(`document.getElementById("${ADSENSE_LOADER_ID}")`);
    expect(s).toContain("s.async=true");
    expect(s).toContain(JSON.stringify(adsenseScriptSrc(CLIENT)));
    expect(adsenseScriptSrc(CLIENT)).toContain(CLIENT);
  });
});
