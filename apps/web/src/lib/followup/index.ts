/**
 * Postpartum condition follow-up (E4, P2.4b).
 *
 * ## The cliff this exists for
 *
 * E4 §A: during pregnancy she was watched weekly, and after delivery the system's
 * attention transfers to the baby while her own follow-up evaporates. Only a
 * minority of women with gestational diabetes complete the recommended postpartum
 * glucose test, and a blood-pressure check after a hypertensive pregnancy is missed
 * even when the baby is in a tertiary unit. Femio's part is **education and a
 * reminder, never care** — the schedule, and the fact that it exists at all.
 *
 * ## What this module is not
 *
 * **It records no result and reads none.** There is no `value`, no `normal`, no
 * `passed` — the fourth time this codebase has made that call after ADR-049's
 * missing `result` column, R2.3's verdict-free `ClinicalStrip` and P2.4's
 * grade-refusing MRS. A follow-up that stored an outcome would be a screen telling
 * a woman what her test meant, which is her clinician's sentence to say.
 *
 * **It does not decide that she needs one.** The trigger is a condition *she
 * reported* — the postpartum triage already asks — and the windows below are the
 * ones published guidance describes. Femio surfaces the schedule attached to what
 * she told us; it never infers a condition from a symptom and then schedules for it.
 *
 * **`overdue` is arithmetic, not a judgement.** It means the window guidance
 * describes has closed, and the copy that renders it says "worth chasing" rather
 * than anything about her. Nobody is graded for missing an appointment they were
 * never offered — which, per §A, is the usual reason.
 */

/** Condition codes that carry a follow-up past the birth. Mirrors the resolver's. */
export type FollowUpTrigger =
  | "gestational_diabetes"
  | "diabetes"
  | "hypertension"
  | "pre_eclampsia";

export type FollowUpKind = "glucose" | "bloodPressure";

export type FollowUp = {
  kind: FollowUpKind;
  /** Days after birth the window opens and closes, per published guidance. */
  fromDay: number;
  toDay: number;
  /**
   * Where today sits against that window. Never a statement about her health, and
   * deliberately not called `missed`.
   */
  status: "upcoming" | "open" | "overdue";
};

/**
 * The windows, as guidance describes them, in one place.
 *
 * Written as data rather than as branches so a twin Dart implementation reads the
 * same numbers, and so changing one is a reviewed diff rather than an edit inside
 * a condition. Ranges are deliberately wide: they are the windows guidance names,
 * and narrowing them to a single day would turn a range into an appointment date
 * Femio has no business setting.
 */
const WINDOWS: Record<FollowUpKind, { fromDay: number; toDay: number }> = {
  /**
   * The postpartum glucose test after a pregnancy affected by diabetes. Guidance
   * describes roughly four to twelve weeks after birth — the test E4 §A names as
   * the one most often skipped.
   */
  glucose: { fromDay: 28, toDay: 84 },
  /**
   * Blood-pressure review after a hypertensive pregnancy. The early check sits in
   * the first days and the second around a week to ten days; this carries the
   * outer bound, because a woman reading it three days after birth and a woman
   * reading it on day nine both need to know it is not finished.
   */
  bloodPressure: { fromDay: 0, toDay: 10 },
};

/** Which kinds a set of reported conditions calls for. Order is stable. */
export function followUpKindsFor(conditions: readonly string[]): FollowUpKind[] {
  const kinds: FollowUpKind[] = [];
  if (conditions.includes("gestational_diabetes") || conditions.includes("diabetes")) {
    kinds.push("glucose");
  }
  if (conditions.includes("hypertension") || conditions.includes("pre_eclampsia")) {
    kinds.push("bloodPressure");
  }
  return kinds;
}

/** Whole days from `fromISO` to `toISO`. Both are plain `YYYY-MM-DD`. */
function daysBetween(fromISO: string, toISO: string): number {
  const a = Date.UTC(+fromISO.slice(0, 4), +fromISO.slice(5, 7) - 1, +fromISO.slice(8, 10));
  const b = Date.UTC(+toISO.slice(0, 4), +toISO.slice(5, 7) - 1, +toISO.slice(8, 10));
  return Math.round((b - a) / 86_400_000);
}

/**
 * The follow-ups worth showing her, given what she reported and when she gave
 * birth. Returns `[]` when either is unknown — a schedule with no birth date to
 * anchor it would be a guess, and this is not a surface that guesses.
 */
export function followUpsFor(input: {
  conditions: readonly string[];
  birthDateISO: string | null;
  todayISO: string;
}): FollowUp[] {
  const { conditions, birthDateISO, todayISO } = input;
  if (!birthDateISO) return [];

  const age = daysBetween(birthDateISO, todayISO);
  // A birth date in the future is a typo, not a pregnancy. Say nothing rather than
  // count down to a follow-up.
  if (age < 0) return [];

  return followUpKindsFor(conditions).map((kind) => {
    const { fromDay, toDay } = WINDOWS[kind];
    const status: FollowUp["status"] =
      age < fromDay ? "upcoming" : age <= toDay ? "open" : "overdue";
    return { kind, fromDay, toDay, status };
  });
}
