import { describe, expect, it } from "vitest";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { predictNextPeriod } from "./cycle/predict";
import { fertileWindow } from "./calculators";
import { addDays } from "./calculators/dates";
import { ttcGuidance, type TryingFor } from "./fertility/guidance";
import { bbtChart, type FertilityEntry } from "./fertility";
import { inProgress, summarize, timeContractions, type Contraction } from "./contractions";
import { comparePattern, type MovementSession } from "./pregnancy/movements";
import { weightChart, type WeightEntry } from "./vitals/weight";
import {
  awaitingResults,
  daysUntil,
  nextAppointment,
  splitAppointments,
  type Appointment,
} from "./appointments";
import { hijriDay, hijriMonthLine, hijriMonthYear } from "./calendar/grid";
import { eddFromConception, eddFromLmp, eddFromTransfer, pregnancyProgress } from "./pregnancy";
import { pregnancyTestDay, pregnancyToolOrder } from "./pregnancy/tools";

/**
 * The golden fixtures (R2.4, `docs/24` §4).
 *
 * The same rule exists twice — once in TypeScript (the website's calculators) and
 * once in Dart (the app). That is the
 * one spot drift can happen, and **drift here means two clients disagreeing about a
 * woman's health**: one telling her she is 24 weeks pregnant and the other 25, or
 * one surfacing a thyroid strip the other hides.
 *
 * So the fixtures are plain JSON at the repo root rather than TypeScript. This suite
 * loads them; the Dart suite will load the **same files**. New behaviour lands as a
 * new fixture *before* it lands as code in either language, which is what stops a
 * Dart implementation quietly diverging and a TS change quietly breaking the app.
 *
 * Regenerating them by running the implementation would defeat the purpose — a
 * fixture that always matches proves nothing. They are committed, and a change to
 * one is a change a reviewer has to look at.
 */

const DIR = join(process.cwd(), "..", "..", "fixtures", "domain");

function load(name: string): { cases: Array<{ input: never; expected: unknown }> } {
  return JSON.parse(readFileSync(join(DIR, `${name}.json`), "utf8"));
}

/** Every fixture file must be executed by a case below — an unrun fixture is a lie. */
const RUNNERS: Record<string, (input: never) => unknown> = {
  "cycle-prediction": (i: { starts: string[]; statedCycleLength?: number }) =>
    predictNextPeriod(i.starts, i.statedCycleLength),
  "bbt-chart": (i: { cycleStart: string | null; entries: Array<{ id: string; loggedAt: string; bbt: number }> }) => {
    const r4 = (n: number) => Math.round(n * 10_000) / 10_000;
    const entries: FertilityEntry[] = i.entries.map((e) => ({ ...e, opk: null, cm: null, intercourse: null }));
    const chart = bbtChart(entries, i.cycleStart);
    return chart && { ...chart, low: r4(chart.low), high: r4(chart.high), points: chart.points.map((p) => ({ ...p, y: r4(p.y) })) };
  },
  contractions: (i: { contractions: Contraction[] }) => {
    const timed = timeContractions(i.contractions);
    return {
      timed: timed.map(({ id, durationSeconds, intervalSeconds }) => ({ id, durationSeconds, intervalSeconds })),
      summary: summarize(timed),
      inProgress: inProgress(timed)?.id ?? null,
    };
  },
  "movement-pattern": (i: { sessions: MovementSession[] }) => {
    const r4 = (n: number) => Math.round(n * 10_000) / 10_000;
    const r = comparePattern(i.sessions);
    return r.status === "insufficient"
      ? r
      : {
          ...r,
          typicalMinutesPerMovement: r4(r.typicalMinutesPerMovement),
          latestMinutesPerMovement: r4(r.latestMinutesPerMovement),
          ratio: r4(r.ratio),
        };
  },
  "weight-chart": (i: { entries: WeightEntry[] }) => {
    const r4 = (n: number) => Math.round(n * 10_000) / 10_000;
    const c = weightChart(i.entries);
    return c && { ...c, low: r4(c.low), high: r4(c.high), points: c.points.map((p) => ({ ...p, y: r4(p.y) })) };
  },
  appointments: (i: { today: string; appointments: Appointment[] }) => {
    const s = splitAppointments(i.appointments, i.today);
    return {
      upcoming: s.upcoming.map((a) => a.id),
      past: s.past.map((a) => a.id),
      next: nextAppointment(i.appointments, i.today)?.id ?? null,
      awaiting: awaitingResults(i.appointments, i.today).map((a) => a.id),
      daysUntil: Object.fromEntries(i.appointments.map((a) => [a.id, daysUntil(a, i.today)])),
    };
  },
  "fertile-window": (i: { nextPeriod: string; cycleLength: number | null; irregular: boolean; learning: boolean }) => {
    if (i.irregular || i.learning || i.cycleLength === null) return null;
    const lmp = addDays(i.nextPeriod, -i.cycleLength);
    const window = fertileWindow(lmp, i.cycleLength)?.window ?? null;
    return window && { ovulation: window.ovulation, windowStart: window.start, windowEnd: window.end };
  },
  "ttc-guidance": (i: { tryingFor: TryingFor | null; age: number | null; irregular: boolean }) => ttcGuidance(i),
  "pregnancy-tools": (i: { weeks: number | null }) => pregnancyToolOrder(i.weeks),
  "test-timing": (i: { windowEnd: string; irregular: boolean }) => pregnancyTestDay(i.windowEnd, i.irregular),
  "edd-from": (i: { method: "lmp" | "conception" | "transfer3" | "transfer5"; date: string }) =>
    i.method === "lmp"
      ? eddFromLmp(i.date)
      : i.method === "conception"
        ? eddFromConception(i.date)
        : eddFromTransfer(i.date, i.method === "transfer3" ? 3 : 5),
  "gestational-age": (i: { edd: string; today: string }) => pregnancyProgress(i.edd, i.today),
  // Two kinds of case share the file: an ISO date (day, month index, year) and a
  // Gregorian span (the Arabic month line under the month title).
  hijri: (i: { iso?: string; first?: string; last?: string }) =>
    i.iso !== undefined
      ? { day: hijriDay(i.iso), ...hijriMonthYear(i.iso) }
      : { line: hijriMonthLine(i.first as string, i.last as string) },
};

describe("golden fixtures", () => {
  it("runs every fixture file on disk — an unexecuted fixture proves nothing", () => {
    const onDisk = readdirSync(DIR)
      .filter((f) => f.endsWith(".json"))
      .map((f) => f.replace(/\.json$/, ""))
      .sort();
    expect(onDisk).toEqual(Object.keys(RUNNERS).sort());
  });

  for (const [name, run] of Object.entries(RUNNERS)) {
    describe(name, () => {
      const { cases } = load(name);

      it("has cases", () => {
        expect(cases.length).toBeGreaterThan(0);
      });

      cases.forEach((testCase, index) => {
        it(`case ${index} matches the recorded answer`, () => {
          // `toEqual` rather than `toStrictEqual`: the JSON round-trip drops
          // `undefined` members, and a Dart implementation will not have them
          // either. What has to match is the *value*, not the encoding.
          expect(run(testCase.input)).toEqual(testCase.expected);
        });
      });
    });
  }
});
