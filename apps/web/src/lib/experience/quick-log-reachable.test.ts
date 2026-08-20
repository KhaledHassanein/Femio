import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import { PERSONA_RECORDS } from "./registry";

/**
 * The log button must exist on every dashboard that asks for one (found live,
 * 2026-08-19).
 *
 * ## The bug this exists for
 *
 * `dashboard-screen` renders its own accent "Log" button **unless the served
 * document already contains a `quickLog` module** — R2.5e added that suppression
 * because pregnancy and postpartum were stacking two identical full-width CTAs.
 * The suppression is correct and the test it used was the document rather than the
 * mode, which was also correct.
 *
 * It rests on one unstated assumption: *if the document carries `quickLog`, some
 * component renders it.* R1.9a, R1.9c and R1.9e each added an experience component
 * that passed `quickLog: null`, and Tracks B, C and F all contribute the module —
 * so the suppression fired, the module rendered nothing, and **three live
 * dashboards lost their log button entirely**. The cycle dashboard told a new user
 * "log a couple of periods to unlock insights" with no way to log one.
 *
 * Nothing caught it. `UNIMPLEMENTED` could not: `quickLog` *is* implemented, and
 * the coverage test asserts an id has a renderer, not that a caller passes a real
 * node. This is the same shape as P2.7a — a listed id proves the gap is known, not
 * that the wiring is right — arriving from the opposite direction.
 *
 * ## What this asserts
 *
 * No experience component may pass `quickLog: null`. Reading the source is crude
 * and it is the level the bug lives at: the type is `ReactNode`, so `null`
 * type-checks perfectly, and only the rendered screen or this ever notices.
 */

const COMPONENT_DIRS = [
  "src/components/experience",
  "src/components/menopause",
  "src/components/dashboard",
];

function sourcesUnder(dir: string): { file: string; text: string }[] {
  let entries: string[];
  try {
    entries = readdirSync(dir);
  } catch {
    return [];
  }
  return entries
    .filter((f) => f.endsWith(".tsx") && !f.endsWith(".test.tsx"))
    .map((f) => ({ file: join(dir, f), text: readFileSync(join(dir, f), "utf8") }));
}

const SOURCES = COMPONENT_DIRS.flatMap(sourcesUnder);

describe("the log button reaches every dashboard that asks for one", () => {
  it("has files to scan — a vacuous pass here would hide the whole bug", () => {
    expect(SOURCES.length).toBeGreaterThan(3);
  });

  it("never lets a component swallow the quickLog module", () => {
    const offenders = SOURCES.filter(({ text }) => /quickLog:\s*null/.test(text)).map(
      ({ file }) => file,
    );
    expect(offenders).toEqual([]);
  });

  /**
   * And the other half of the pair: the suppression in `dashboard-screen` is only
   * safe while it keys on the document. If it ever becomes a mode list again it
   * goes stale the next time a registry row changes, which is the reason R2.5e
   * gave for not writing one.
   */
  it("keeps the dashboard's own suppression keyed on the served document", () => {
    const screen = SOURCES.find(({ file }) => file.endsWith("dashboard-screen.tsx"));
    expect(screen).toBeDefined();
    expect(screen!.text).toMatch(/config\?\.home\.modules\.some\(\(m\) => m\.id === "quickLog"\)/);
  });

  /** Most tracks offer it; the test above is worth having because they do. */
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
