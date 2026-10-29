import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { AD_CONSENT_POLL_MS, consentUpdateGrantsAds, queueGrantsAds, waitForAdConsent } from "./ad-consent";

/** gtag queues its `arguments` object, which is array-like, not an array. */
function gtagArgs(...args: unknown[]): ArrayLike<unknown> {
  return (function () {
    // eslint-disable-next-line prefer-rest-params
    return arguments;
  })(...(args as []));
}

describe("ads only after consent (ADR-075)", () => {
  it("recognises a consent update that grants ad_storage, in either shape", () => {
    expect(consentUpdateGrantsAds(["consent", "update", { ad_storage: "granted" }])).toBe(true);
    expect(consentUpdateGrantsAds(gtagArgs("consent", "update", { ad_storage: "granted", analytics_storage: "denied" }))).toBe(true);
  });

  it("ignores the default, a denial, analytics-only consent and ordinary events", () => {
    expect(consentUpdateGrantsAds(["consent", "default", { ad_storage: "granted" }])).toBe(false);
    expect(consentUpdateGrantsAds(["consent", "update", { ad_storage: "denied" }])).toBe(false);
    expect(consentUpdateGrantsAds(["consent", "update", { analytics_storage: "granted" }])).toBe(false);
    expect(consentUpdateGrantsAds({ event: "calculator_used", calculator_slug: "period" })).toBe(false);
    expect(consentUpdateGrantsAds(null)).toBe(false);
    expect(consentUpdateGrantsAds("consent")).toBe(false);
  });

  it("reads the whole queue and lets the latest answer win", () => {
    expect(queueGrantsAds(undefined)).toBe(false);
    expect(queueGrantsAds([])).toBe(false);
    expect(queueGrantsAds([["consent", "default", { ad_storage: "denied" }]])).toBe(false);
    expect(queueGrantsAds([["consent", "default", { ad_storage: "denied" }], gtagArgs("consent", "update", { ad_storage: "granted" })])).toBe(true);
    expect(
      queueGrantsAds([
        ["consent", "update", { ad_storage: "granted" }],
        ["consent", "update", { ad_storage: "denied" }],
      ]),
    ).toBe(false);
  });

  describe("waitForAdConsent", () => {
    beforeEach(() => vi.useFakeTimers());
    afterEach(() => vi.useRealTimers());

    it("fires at once when consent was already given", () => {
      const onGranted = vi.fn();
      waitForAdConsent(onGranted, () => [["consent", "update", { ad_storage: "granted" }]]);
      expect(onGranted).toHaveBeenCalledTimes(1);
    });

    it("waits for the visitor's Allow, fires once, then stops polling", () => {
      const queue: unknown[] = [["consent", "default", { ad_storage: "denied" }]];
      const onGranted = vi.fn();
      waitForAdConsent(onGranted, () => queue);
      vi.advanceTimersByTime(AD_CONSENT_POLL_MS * 3);
      expect(onGranted).not.toHaveBeenCalled();
      queue.push(["consent", "update", { ad_storage: "granted" }]);
      vi.advanceTimersByTime(AD_CONSENT_POLL_MS);
      expect(onGranted).toHaveBeenCalledTimes(1);
      vi.advanceTimersByTime(AD_CONSENT_POLL_MS * 5);
      expect(onGranted).toHaveBeenCalledTimes(1);
    });

    it("never fires when there is no dataLayer at all, and can be cancelled", () => {
      const onGranted = vi.fn();
      const stop = waitForAdConsent(onGranted, () => undefined);
      vi.advanceTimersByTime(AD_CONSENT_POLL_MS * 5);
      stop();
      vi.advanceTimersByTime(AD_CONSENT_POLL_MS * 5);
      expect(onGranted).not.toHaveBeenCalled();
    });
  });
});
