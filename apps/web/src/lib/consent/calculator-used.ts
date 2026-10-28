import { track } from "./events";

/**
 * `calculator_used`: the first tap on a calculator's calendar in this page view
 * (ADR-075 event list). Only the calculator's slug travels; the day she tapped stays
 * in the browser. The calendar component calls this from its tap handler, which is
 * the one place that knows a tap happened, and this module makes sure it fires once.
 */
const used = new Set<string>();

export function trackCalculatorUsed(): void {
  if (typeof window === "undefined") return;
  const parts = window.location.pathname.split("/").filter(Boolean);
  if (parts[1] !== "calculators" || !parts[2]) return;
  const slug = parts[2];
  if (used.has(slug)) return;
  used.add(slug);
  track("calculator_used", { calculator_slug: slug });
}

/** Test hook: forget what was tracked. */
export function resetCalculatorUsed(): void {
  used.clear();
}
