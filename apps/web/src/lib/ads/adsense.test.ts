import { describe, expect, it } from "vitest";
import { ADSENSE_HOST, ADSENSE_SELLER_ID, adsTxt, adsenseScriptSrc, appAdsTxt, isAdMobPublisher, isAdSenseClient, isAdSlot } from "./adsense";
import { adUnitConfig, adsEnabled, HUB_UNIT_AFTER_CARDS } from "./placements";

describe("AdSense ids (R6.8)", () => {
  it("accepts only a publisher id in the ad-code form", () => {
    expect(isAdSenseClient("ca-pub-1234567890123456")).toBe(true);
    expect(isAdSenseClient("pub-1234567890123456")).toBe(false); // the ads.txt form, not the ad-code form
    expect(isAdSenseClient("ca-pub-12")).toBe(false);
    expect(isAdSenseClient("ca-pub-1234567890123456'); alert(1); ('")).toBe(false);
    expect(isAdSenseClient(undefined)).toBe(false);
    expect(isAdSenseClient("")).toBe(false);
  });

  it("accepts only a numeric slot id", () => {
    expect(isAdSlot("1234567890")).toBe(true);
    expect(isAdSlot("12")).toBe(false);
    expect(isAdSlot("abc")).toBe(false);
    expect(isAdSlot(undefined)).toBe(false);
  });

  it("builds the loader URL for the one allowed host and refuses a bad id", () => {
    expect(adsenseScriptSrc("ca-pub-1234567890123456")).toBe(
      `https://${ADSENSE_HOST}/pagead/js/adsbygoogle.js?client=ca-pub-1234567890123456`,
    );
    expect(() => adsenseScriptSrc("not-an-id")).toThrow();
  });
});

describe("ads.txt", () => {
  it("names Google as the only direct seller, with the pub- form of the id", () => {
    expect(adsTxt("ca-pub-1234567890123456")).toBe(`google.com, pub-1234567890123456, DIRECT, ${ADSENSE_SELLER_ID}\n`);
  });

  it("holds no sellers when advertising is not configured", () => {
    const body = adsTxt(undefined);
    expect(body.startsWith("#")).toBe(true);
    expect(body).not.toContain("google.com,");
    expect(adsTxt("garbage")).toBe(body);
  });
});

describe("app-ads.txt (ADR-076)", () => {
  it("accepts the AdMob publisher id form only", () => {
    expect(isAdMobPublisher("pub-1234567890123456")).toBe(true);
    expect(isAdMobPublisher("ca-pub-1234567890123456")).toBe(false);
    expect(isAdMobPublisher("pub-12")).toBe(false);
    expect(isAdMobPublisher(undefined)).toBe(false);
  });

  it("names Google as the app's direct seller, and nobody without an id", () => {
    expect(appAdsTxt("pub-1234567890123456")).toBe(`google.com, pub-1234567890123456, DIRECT, ${ADSENSE_SELLER_ID}\n`);
    expect(appAdsTxt(undefined).startsWith("#")).toBe(true);
    expect(appAdsTxt(undefined)).not.toContain("google.com,");
  });
});

describe("placements", () => {
  it("is off by default: the test environment sets no publisher id", () => {
    expect(adsEnabled()).toBe(false);
    expect(adUnitConfig("article-mid")).toBeNull();
    expect(adUnitConfig("article-end")).toBeNull();
    expect(adUnitConfig("hub-top")).toBeNull();
  });

  it("renders a unit only when both the publisher id and that placement's slot are set", () => {
    const client = "ca-pub-1234567890123456";
    expect(adUnitConfig("article-mid", { client, slot: "1234567890" })).toEqual({
      client,
      slot: "1234567890",
      placement: "article-mid",
    });
    expect(adUnitConfig("article-mid", { client, slot: undefined })).toBeNull();
    expect(adUnitConfig("article-mid", { client: undefined, slot: "1234567890" })).toBeNull();
    expect(adUnitConfig("article-mid", { client, slot: "<script>" })).toBeNull();
  });

  it("keeps the hub unit below a phone's first screen", () => {
    expect(HUB_UNIT_AFTER_CARDS).toBeGreaterThanOrEqual(3);
  });
});
