import { describe, expect, it } from "vitest";
import { IMPLEMENTED, UNIMPLEMENTED } from "./module-registry";
import { TRACK_D_RECORDS } from "@/lib/experience/registry/track-d";
import type { ModuleId } from "@/lib/experience/types";

/**
 * The coverage contract.
 *
 * The registry declares more modules than are built, which is fine — what is not
 * fine is a module vanishing silently, because the engine would look correct while
 * a woman's screen quietly lost a panel. So every id the persona registry can emit
 * must be either **implemented** or **explicitly listed as unimplemented**, and
 * this test is what makes the gap a tracked number instead of a surprise.
 */
describe("module registry coverage", () => {
  const declared = new Set<ModuleId>(
    TRACK_D_RECORDS.flatMap((r) => Object.values(r.home).flat().map((m) => m!.id)),
  );

  it("accounts for every module Track D can emit", () => {
    const accounted = new Set<ModuleId>([...IMPLEMENTED, ...UNIMPLEMENTED]);
    const missing = [...declared].filter((id) => !accounted.has(id));
    expect(missing, "declared by a persona but neither implemented nor listed").toEqual([]);
  });

  it("does not list an id as unimplemented once it is built", () => {
    const overlap = UNIMPLEMENTED.filter((id) => IMPLEMENTED.includes(id));
    expect(overlap, "listed as unimplemented but present in RENDERERS").toEqual([]);
  });

  /**
   * The R2.3 acceptance test, stated as coverage: the two strips that make D3 and
   * D7 different screens have to be built, or the engine proves nothing.
   */
  it("implements the modules that differentiate the personas", () => {
    expect(IMPLEMENTED).toContain("strip.thyroid");
    expect(IMPLEMENTED).toContain("strip.glucose");
    expect(IMPLEMENTED).toContain("pregnancy.week");
    expect(IMPLEMENTED).toContain("pregnancy.warningSigns");
  });
});
