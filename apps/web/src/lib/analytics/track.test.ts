import { describe, expect, it } from "vitest";
import { track } from "./track";
import { createMemoryTransport } from "./transport";
import { isApprovedPostHogHost } from "./host";

const configured = () => true;
const consented = async () => true;

describe("track — the three gates", () => {
  it("sends nothing when no key is configured (today's production state)", async () => {
    const transport = createMemoryTransport();
    const result = await track(
      "page_viewed",
      { area: "home", locale: "en" },
      { transport, isConfigured: () => false, consent: consented },
    );
    expect(result).toEqual({ sent: false, reason: "not_configured" });
    expect(transport.captured).toEqual([]);
  });

  it("sends nothing without analytics consent, even when configured", async () => {
    const transport = createMemoryTransport();
    const result = await track(
      "page_viewed",
      { area: "home", locale: "en" },
      { transport, isConfigured: configured, consent: async () => false },
    );
    expect(result).toEqual({ sent: false, reason: "no_consent" });
    expect(transport.captured).toEqual([]);
  });

  it("checks consent before sending, not after", async () => {
    // Ordering is a privacy property: the consent answer must be known before
    // anything leaves the browser.
    const order: string[] = [];
    const transport = createMemoryTransport();
    await track(
      "page_viewed",
      { area: "home", locale: "en" },
      {
        transport: {
          name: "ordered",
          capture: (...args) => {
            order.push("capture");
            transport.capture(...args);
          },
        },
        isConfigured: () => {
          order.push("config");
          return true;
        },
        consent: async () => {
          order.push("consent");
          return true;
        },
      },
    );
    expect(order).toEqual(["config", "consent", "capture"]);
  });

  it("sends an allowlisted event once both gates are open", async () => {
    const transport = createMemoryTransport();
    const result = await track(
      "signin_completed",
      { locale: "fr", auth_method: "magic_link", outcome: "success" },
      { transport, isConfigured: configured, consent: consented },
    );
    expect(result).toEqual({ sent: true });
    expect(transport.captured).toEqual([
      { event: "signin_completed", props: { locale: "fr", auth_method: "magic_link", outcome: "success" } },
    ]);
  });

  it("drops a payload the guard rejects rather than throwing", async () => {
    const transport = createMemoryTransport();
    const result = await track(
      "page_viewed",
      // Cast: the point is to simulate an unsafe value arriving at runtime, which
      // is exactly what the guard exists to stop once types are erased.
      { area: "library", locale: "en", symptom: "cramps" } as never,
      { transport, isConfigured: configured, consent: consented },
    );
    expect(result.sent).toBe(false);
    expect(result.sent === false && result.reason).toBe("rejected");
    expect(transport.captured).toEqual([]);
  });
});

describe("isApprovedPostHogHost", () => {
  it("accepts the PostHog EU hosts over HTTPS", () => {
    expect(isApprovedPostHogHost("https://eu.i.posthog.com")).toBe(true);
    expect(isApprovedPostHogHost("https://eu.posthog.com")).toBe(true);
  });

  it("rejects the US cloud — the SDK default, and an unmandated transfer", () => {
    expect(isApprovedPostHogHost("https://us.i.posthog.com")).toBe(false);
    expect(isApprovedPostHogHost("https://app.posthog.com")).toBe(false);
  });

  it("rejects non-HTTPS, look-alike hosts, and query strings", () => {
    expect(isApprovedPostHogHost("http://eu.i.posthog.com")).toBe(false);
    expect(isApprovedPostHogHost("https://eu.i.posthog.com.evil.com")).toBe(false);
    expect(isApprovedPostHogHost("https://eu.i.posthog.com/?uid=123")).toBe(false);
    expect(isApprovedPostHogHost("not a url")).toBe(false);
  });
});
