import { describe, expect, it } from "vitest";
import { IMPLEMENTED } from "@/components/experience/module-registry";
import type { ModuleContext } from "@/components/experience/module-registry";
import { PERSONA_RECORDS } from "./registry";

/**
 * The log button must exist on every dashboard that asks for one (found live,
 * 2026-08-19).
 *
 * ## The bug this exists for
 *
 * `dashboard-screen` renders the log CTA **unless the served document already
 * contains a `quickLog` module** — R2.5e added that suppression because pregnancy
 * and postpartum were stacking two identical full-width CTAs. The suppression is
 * correct, and keying it on the document rather than the mode was correct too.
 *
 * It rested on one unstated assumption: *if the document carries `quickLog`, some
 * component renders it.* `quickLog` was a `ReactNode` slot on `ModuleContext`, so
 * R1.9a, R1.9c and R1.9e each added an experience component that filled it with
 * `null` — which type-checks perfectly. Tracks B, C and F all contribute the
 * module, so the suppression fired, the module rendered nothing, and **three live
 * dashboards lost their log button entirely**. The cycle dashboard told a new user
 * "log a couple of periods to unlock insights" with no way to log one.
 *
 * Nothing caught it. `UNIMPLEMENTED` could not: `quickLog` *is* implemented, and
 * the coverage test asserts an id has a renderer, not that a caller passes a real
 * node. Same shape as P2.7a — a listed id proves the gap is known, not that the
 * wiring is right — arriving from the opposite direction.
 *
 * ## What this asserts
 *
 * R1.9m removed the slot: the registry now draws `QuickLogButton` itself, so there
 * is nothing left for a caller to null out and the failure is unrepresentable
 * rather than merely tested for. What remains worth holding is the pair the
 * suppression depends on — the id is renderable, and the personas ask for it.
 */

/**
 * The slot must stay gone. A compile-time assertion, not a runtime one: reviving
 * `quickLog` on `ModuleContext` is exactly how the bug returns, and this fails
 * `tsc --noEmit` the moment someone does.
 */
type SlotIsGone = "quickLog" extends keyof ModuleContext ? never : true;
export const QUICK_LOG_SLOT_IS_GONE: SlotIsGone = true;

describe("the log button reaches every dashboard that asks for one", () => {
  it("is rendered by the registry, which is what makes the suppression safe", () => {
    expect(IMPLEMENTED).toContain("quickLog");
  });

  /** Most tracks offer it; the assertion above is worth having because they do. */
  it("is offered by the tracks that have dashboards", () => {
    const offering = new Set(
      PERSONA_RECORDS.filter((r) =>
        Object.values(r.home).some((mods) => mods?.some((m) => m.id === "quickLog")),
      ).map((r) => r.track),
    );
    for (const track of ["A", "B", "C", "D", "E", "F"]) {
      expect([...offering]).toContain(track);
    }
  });
});
