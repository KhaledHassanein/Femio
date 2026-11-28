// Synthetic data for the website's app demos (R2.10): no real person's record, ever.
//
// Why it exists: the demos on `/app` and the home page show what the app does, so they must
// run the app's rules on believable data without touching anyone's log. Everything a demo
// shows is computed here from these samples with the same shared rules the app uses
// (`lib/cycle/predict.ts`, `lib/cycle/upcoming.ts`, twins of the Dart domain), so the website
// cannot promise a behaviour the app does not have. The sample sentences for "Say it" map to
// the chips the app's rule floor finds in them (checked against `draftFromNote` in Dart on
// 2026-11-24, without Gemini Nano).

import { addDays, diffDays } from "../calculators/dates.ts";
import { predictNextPeriod, type CyclePrediction } from "../cycle/predict.ts";
import { upcomingPeriods, type UpcomingPeriod } from "../cycle/upcoming.ts";

/** The three period patterns the calendar demo offers. */
export const PERIOD_PATTERNS = ["regular", "varies", "new"] as const;
export type PeriodPattern = (typeof PERIOD_PATTERNS)[number];

type PatternSample = { starts: string[]; statedLength: number | null };

/**
 * Period starts per pattern, all ending on the same autumn day so the timelines line up.
 * `regular`: 28/29/28-day gaps; `varies`: 24/35/27; `new`: one start plus a stated 28.
 */
const PERIOD_SAMPLES: Record<PeriodPattern, PatternSample> = {
  regular: { starts: ["2026-08-04", "2026-09-01", "2026-09-30", "2026-10-28"], statedLength: null },
  varies: { starts: ["2026-07-30", "2026-08-23", "2026-09-27", "2026-10-24"], statedLength: null },
  new: { starts: ["2026-10-28"], statedLength: 28 },
};

export type PeriodDemo = {
  lastStart: string;
  prediction: CyclePrediction | null;
  periods: UpcomingPeriod[];
};

/**
 * Runs the app's prediction rules on one sample pattern.
 *
 * @param pattern - which sample to use.
 * @returns the last logged start, the prediction, and the upcoming periods (three when the
 *   cycles are regular, one when they vary or are still being learned, per MR-51).
 */
export function periodDemo(pattern: PeriodPattern): PeriodDemo {
  const sample = PERIOD_SAMPLES[pattern];
  const prediction = predictNextPeriod(sample.starts, sample.statedLength);
  return {
    lastStart: sample.starts[sample.starts.length - 1]!,
    prediction,
    periods: upcomingPeriods(prediction),
  };
}

/** Days of axis drawn after the last range ends, so the last band never touches the edge. */
const TIMELINE_TAIL_DAYS = 6;

export type PeriodTimeline = {
  /** Each upcoming range as a share of the axis (0-100), from the inline start. */
  bars: { from: number; width: number; low: boolean }[];
  /** The first day of each month on the axis, with its position. */
  ticks: { iso: string; at: number }[];
};

/**
 * Lays a demo's upcoming periods on an axis that starts at her last logged period.
 *
 * @param demo - from {@link periodDemo}.
 * @returns bar and month-tick positions in percent; drawing is the component's job.
 */
export function periodTimeline(demo: PeriodDemo): PeriodTimeline {
  const start = demo.lastStart;
  const last = demo.periods[demo.periods.length - 1];
  const end = addDays(last ? last.windowEnd : addDays(start, 35), TIMELINE_TAIL_DAYS);
  const span = Math.max(1, diffDays(start, end));
  const at = (iso: string) => (diffDays(start, iso) / span) * 100;
  const ticks: { iso: string; at: number }[] = [];
  for (let d = addDays(start, 1); diffDays(d, end) > 0; d = addDays(d, 1)) {
    if (d.endsWith("-01")) ticks.push({ iso: d, at: at(d) });
  }
  return {
    bars: demo.periods.map((p) => ({ from: at(p.windowStart), width: at(p.windowEnd) - at(p.windowStart), low: p.confidence === "low" })),
    ticks,
  };
}

/** The sample sentences for "Say it", keyed as in `appDemo.sayIt.samples`. */
export const SAY_IT_SAMPLES = ["cramps", "bloated", "back"] as const;
export type SayItSample = (typeof SAY_IT_SAMPLES)[number];

/** The log chips the app's rule floor finds in each sample sentence, in sentence order. */
export const SAY_IT_TERMS: Record<SayItSample, readonly SayItTerm[]> = {
  cramps: ["cramps", "headache", "fatigue"],
  bloated: ["bloating", "nausea"],
  back: ["backache", "anxious"],
};
export type SayItTerm = "cramps" | "headache" | "fatigue" | "bloating" | "nausea" | "backache" | "anxious";

/** The questions the Ask femio demo offers, keyed as in `appDemo.ask.questions`. */
export const ASK_QUESTIONS = ["cramps", "bleeding", "uncovered"] as const;
export type AskQuestion = (typeof ASK_QUESTIONS)[number];

/**
 * How the app handles each demo question: a cited answer, the safety rule that runs before
 * any model (MR-50 heavy bleeding with dizziness), or "not covered" when no trusted passage
 * matches.
 */
export const ASK_OUTCOME: Record<AskQuestion, "answer" | "safety" | "notCovered"> = {
  cramps: "answer",
  bleeding: "safety",
  uncovered: "notCovered",
};

/**
 * The registry passage the sample answer stands on: MedlinePlus "Period Pain", a US federal
 * public-domain page bundled in the app (`assets/trusted_sources/registry.json`, entries
 * `medlineplus-period-pain-self-care` and `-when-to-call`).
 */
export const ASK_SOURCE = {
  publisher: "MedlinePlus (NLM)",
  url: "https://medlineplus.gov/periodpain.html",
  reviewed: "2024-08-12",
} as const;

/** The app screens the tour shows, with their pixel size (all rendered at 780 px wide). */
export const TOUR_SCREENS = [
  { key: "today", height: 4200 },
  { key: "calendar", height: 2200 },
  { key: "pregnancy", height: 2740 },
  { key: "ask", height: 1688 },
  { key: "boost", height: 1688 },
  { key: "visit", height: 1688 },
] as const;
export type TourScreen = (typeof TOUR_SCREENS)[number]["key"];

/** Width every tour screenshot was rendered at (390 logical px at 2x). */
export const TOUR_SCREEN_WIDTH = 780;

/**
 * Where a tour screenshot lives. Arabic pages show the Arabic screens, in a dark variant
 * too; every other locale shows the English light screens (the only ones rendered so far).
 *
 * @param screen - which screen.
 * @param locale - the page's locale.
 * @returns paths for the light theme and, when one exists, the dark theme.
 */
export function tourImage(screen: TourScreen, locale: string): { light: string; dark: string | null } {
  if (locale === "ar") {
    return { light: `/app-screens/${screen}-ar-light.webp`, dark: `/app-screens/${screen}-ar-dark.webp` };
  }
  return { light: `/app-screens/${screen}-en-light.webp`, dark: null };
}
