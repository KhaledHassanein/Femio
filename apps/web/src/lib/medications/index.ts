/**
 * Medicines and supplements (P2.4) — the shape, on its own.
 *
 * `public.meds_supplements` is the fourth table with RLS, an index and a place in
 * the GDPR export that nothing has ever written to (`docs/23` §3.2). The queue
 * called this "the HRT log", and HRT is what prompted it — but the table is not
 * HRT-shaped and this module is not either. A woman on levothyroxine, a prenatal
 * vitamin, an antidepressant and a patch has one list, not four, and splitting it
 * by life stage would be the same restriction-by-data-structure the symptom
 * vocabulary just avoided.
 *
 * ## What it holds, and the two things it will not
 *
 * A name, what she takes and when, and whether she is still taking it. That is a
 * record she can read out in a consultation, which is the entire job.
 *
 * **No dosing guidance.** There is no function here that suggests, adjusts,
 * validates or compares a dose, and no field that could carry one. Femio is
 * wellness, education and tracking (product rule 1); the moment it has an opinion
 * about how much of something a woman should take, it is neither.
 *
 * **No adherence score.** No streak, no "missed", no percentage. The tables that
 * grade people on taking their medicine reliably make the worst days worse, and
 * `docs/09` invariant 7 is the reason Femio does not build them. She can see what
 * she is taking and when she started; nothing counts how good she has been at it.
 *
 * Stopping is a first-class state, not a deletion: `active` goes false and the row
 * stays. "I used to be on this" is one of the most useful things in a medical
 * history, and rule 5 — constant EMR, additive layers — says the record never loses
 * what was true.
 */

import { diffDays } from "../calculators/dates.ts";

/** How often she takes it. Her words are allowed; these are the common shapes. */
export const SCHEDULES = ["daily", "twiceDaily", "weekly", "asNeeded", "other"] as const;
export type Schedule = (typeof SCHEDULES)[number];

export type Medication = {
  id: string;
  name: string;
  /** Free text — "50 mcg", "one patch", "half a tablet". Never validated, never advised on. */
  dose: string | null;
  schedule: Schedule | null;
  /** ISO date. Null when she did not remember or did not say. */
  startedOn: string | null;
  /** Set when she stops. The row stays; `active` is what changes. */
  stoppedOn: string | null;
  active: boolean;
  /** Her own note — what it is for, in her words, never Femio's. */
  note: string | null;
};

export const MAX_NAME_LENGTH = 80;
export const MAX_NOTE_LENGTH = 200;

/** Trim and cap. Rejects nothing else: a medicine name is hers to write. */
export function normalizeName(input: string): string | null {
  const value = input.trim().replace(/\s+/g, " ").slice(0, MAX_NAME_LENGTH);
  return value.length > 0 ? value : null;
}

/**
 * Current first, then what she has stopped, most recently stopped at the top.
 *
 * Stopped entries are never hidden — see the module note. What they are is *below*,
 * because "what am I on now" is the question she opened the screen with.
 */
export function splitMedications(medications: readonly Medication[]): {
  current: Medication[];
  stopped: Medication[];
} {
  const current = medications.filter((m) => m.active);
  const stopped = medications.filter((m) => !m.active);
  current.sort((a, b) => a.name.localeCompare(b.name));
  stopped.sort((a, b) => (b.stoppedOn ?? "").localeCompare(a.stoppedOn ?? ""));
  return { current, stopped };
}

/**
 * Whole days since she started. Null when she did not give a date.
 *
 * Displayed as a fact and nothing else. It is **not** a streak: it counts from the
 * date she wrote down, not from doses recorded, and it does not go up for being
 * good or reset for being late — because there is no adherence data here to reset
 * it with, deliberately.
 */
export function daysOn(medication: Medication, todayISO: string): number | null {
  if (!medication.startedOn) return null;
  const end = medication.stoppedOn ?? todayISO;
  const days = diffDays(medication.startedOn, end);
  return days >= 0 ? days : null;
}

/** The `schedule_json` payload. One place, so the two callers cannot disagree. */
export function toScheduleJson(medication: Omit<Medication, "id" | "name" | "active">) {
  return {
    dose: medication.dose,
    schedule: medication.schedule,
    startedOn: medication.startedOn,
    stoppedOn: medication.stoppedOn,
    note: medication.note,
  };
}

/** Read it back, tolerating a row written before a field existed. */
export function fromRow(row: {
  id: string;
  name: string;
  active: boolean;
  schedule_json: unknown;
}): Medication {
  const json = (row.schedule_json ?? {}) as Record<string, unknown>;
  const text = (key: string) => (typeof json[key] === "string" ? (json[key] as string) : null);
  const schedule = text("schedule");
  return {
    id: row.id,
    name: row.name,
    dose: text("dose"),
    schedule: (SCHEDULES as readonly string[]).includes(schedule ?? "")
      ? (schedule as Schedule)
      : null,
    startedOn: text("startedOn"),
    stoppedOn: text("stoppedOn"),
    note: text("note"),
    active: row.active,
  };
}
