import { describe, expect, it } from "vitest";
import { CONSENT_DEFAULTS, CONSENT_DEFAULT_SNIPPET, CONSENT_WAIT_FOR_UPDATE_MS } from "./consent-default";

// ADR-075: a tag may only fire after the visitor agrees. These tests pin the default
// state so a "helpful" edit that grants analytics by default fails the gate.
describe("consent defaults", () => {
  it("denies every signal that could identify or follow a visitor", () => {
    const identifying = [
      "ad_storage",
      "ad_user_data",
      "ad_personalization",
      "analytics_storage",
      "functionality_storage",
      "personalization_storage",
    ] as const;
    for (const key of identifying) expect(CONSENT_DEFAULTS[key], key).toBe("denied");
  });

  it("names all seven Consent Mode v2 signals and nothing else", () => {
    expect(Object.keys(CONSENT_DEFAULTS).sort()).toEqual(
      [
        "ad_personalization",
        "ad_storage",
        "ad_user_data",
        "analytics_storage",
        "functionality_storage",
        "personalization_storage",
        "security_storage",
      ].sort(),
    );
  });

  it("renders the defaults as the first gtag call, with a bounded wait for the banner", () => {
    expect(CONSENT_DEFAULT_SNIPPET.startsWith("window.dataLayer=window.dataLayer||[];")).toBe(true);
    expect(CONSENT_DEFAULT_SNIPPET).toContain("gtag('consent','default',");
    expect(CONSENT_DEFAULT_SNIPPET).toContain('"analytics_storage":"denied"');
    expect(CONSENT_DEFAULT_SNIPPET).toContain('"ad_storage":"denied"');
    expect(CONSENT_DEFAULT_SNIPPET).toContain(`"wait_for_update":${CONSENT_WAIT_FOR_UPDATE_MS}`);
    expect(CONSENT_WAIT_FOR_UPDATE_MS).toBeGreaterThan(0);
    expect(CONSENT_WAIT_FOR_UPDATE_MS).toBeLessThanOrEqual(2000);
    // No "granted" anywhere except the one harmless signal.
    expect(CONSENT_DEFAULT_SNIPPET.match(/granted/g)?.length ?? 0).toBe(1);
  });
});
