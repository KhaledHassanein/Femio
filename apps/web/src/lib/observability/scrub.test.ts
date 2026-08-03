import { describe, expect, it } from "vitest";
import { isApprovedSentryDsn, sentryConnectOrigin } from "./dsn";
import { normalizeUrl, scrubEvent } from "./scrub";

describe("isApprovedSentryDsn", () => {
  it("accepts an EU ingest DSN", () => {
    expect(isApprovedSentryDsn("https://abc123@o1.ingest.de.sentry.io/456")).toBe(true);
  });

  it("rejects the US cluster — the SDK's default, and an unmechanised transfer", () => {
    expect(isApprovedSentryDsn("https://abc123@o1.ingest.us.sentry.io/456")).toBe(false);
    expect(isApprovedSentryDsn("https://abc123@o1.ingest.sentry.io/456")).toBe(false);
  });

  it("rejects a look-alike host", () => {
    expect(isApprovedSentryDsn("https://k@ingest.de.sentry.io.evil.com/1")).toBe(false);
  });

  it("rejects non-HTTPS and malformed DSNs", () => {
    expect(isApprovedSentryDsn("http://abc@o1.ingest.de.sentry.io/456")).toBe(false);
    expect(isApprovedSentryDsn("https://o1.ingest.de.sentry.io/456")).toBe(false); // no key
    expect(isApprovedSentryDsn("not-a-url")).toBe(false);
  });
});

describe("sentryConnectOrigin", () => {
  it("returns just the origin, for the CSP allow-list", () => {
    expect(sentryConnectOrigin("https://abc@o1.ingest.de.sentry.io/456")).toBe(
      "https://o1.ingest.de.sentry.io",
    );
  });

  it("returns null for anything unusable, so the policy can't widen", () => {
    expect(sentryConnectOrigin(undefined)).toBeNull();
    expect(sentryConnectOrigin("nonsense")).toBeNull();
  });
});

describe("normalizeUrl", () => {
  it("replaces a content slug with its pattern — which article must not be inferable", () => {
    expect(normalizeUrl("https://femioapp.com/en/learn/endometriosis-symptoms")).toBe(
      "/[locale]/learn/[slug]",
    );
    expect(normalizeUrl("https://femioapp.com/ar/conditions/pcos")).toBe(
      "/[locale]/conditions/[slug]",
    );
  });

  it("keeps non-slug routes legible, so the report still says what broke", () => {
    expect(normalizeUrl("https://femioapp.com/en/track")).toBe("/[locale]/track");
    expect(normalizeUrl("https://femioapp.com/fr/settings")).toBe("/[locale]/settings");
  });

  it("drops query strings and fragments entirely", () => {
    expect(normalizeUrl("https://femioapp.com/en/learn/pcos?q=heavy+bleeding#s")).toBe(
      "/[locale]/learn/[slug]",
    );
  });

  it("normalizes the locale away — it is an extra identifying attribute", () => {
    expect(normalizeUrl("/ar/dashboard")).toBe("/[locale]/dashboard");
  });

  it("never throws on a malformed url", () => {
    expect(normalizeUrl("::::")).toBe("/::::");
  });
});

describe("scrubEvent", () => {
  it("removes the request body — a failed health write IS the health data", () => {
    const event = scrubEvent({
      request: { url: "https://femioapp.com/en/track", data: { symptom: "cramps", severity: 3 } },
    });
    expect(event.request?.data).toBeUndefined();
  });

  it("normalizes the failing URL instead of dropping it", () => {
    const event = scrubEvent({ request: { url: "https://femioapp.com/en/learn/pcos-diet" } });
    expect(event.request?.url).toBe("/[locale]/learn/[slug]");
  });

  it("removes cookies, query strings and the user", () => {
    const event = scrubEvent({
      request: { url: "/en", cookies: { sb: "token" }, query_string: "q=x" },
      user: { id: "u1", email: "her@example.com" },
    });
    expect(event.request?.cookies).toBeUndefined();
    expect(event.request?.query_string).toBeUndefined();
    expect(event.user).toBeUndefined();
  });

  it("keeps only the two headers that help diagnose a browser failure", () => {
    const event = scrubEvent({
      request: {
        url: "/en",
        headers: { "user-agent": "Chrome", cookie: "sb=token", authorization: "Bearer x" },
      },
    });
    expect(event.request?.headers).toEqual({ "user-agent": "Chrome" });
  });

  it("normalizes breadcrumb URLs — they replay the same trail in sequence", () => {
    const event = scrubEvent({
      breadcrumbs: [
        { data: { from: "/en/learn/pcos", to: "/en/learn/endometriosis" } },
        { data: { url: "https://femioapp.com/en/conditions/fibroids" } },
      ],
    });
    expect(event.breadcrumbs?.[0]?.data).toEqual({
      from: "/[locale]/learn/[slug]",
      to: "/[locale]/learn/[slug]",
    });
    expect(event.breadcrumbs?.[1]?.data?.url).toBe("/[locale]/conditions/[slug]");
  });

  it("drops `extra`, which is free-form and therefore unauditable", () => {
    const event = scrubEvent({ extra: { note: "heavy bleeding since tuesday" } });
    expect(event.extra).toBeUndefined();
  });

  it("survives an event with nothing in it", () => {
    expect(() => scrubEvent({})).not.toThrow();
  });
});
