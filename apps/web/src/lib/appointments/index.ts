/**
 * Appointments (P2.2.3) — the arithmetic, on its own.
 *
 * `public.appointments` has existed since schema v1 and **nothing has ever written
 * to it** (`docs/23` §3.2). The export includes it, the RLS policies cover it, the
 * pregnancy registry has emitted a `pregnancy.appointments` module since R2.1 — and
 * a woman had no way to record a single appointment. This is the missing half.
 *
 * Pure and clock-injected, like the rest of tier 2: sorting, splitting and "is a
 * result overdue" are the kind of small date logic that goes wrong quietly, and the
 * Dart client will need exactly the same answers. Nothing here decides anything
 * medical, and there is no field it could decide it in — see below.
 *
 * ## What an appointment record deliberately does not have
 *
 * **No outcome, no status, no "normal".** The row carries when, with whom, what
 * kind, what to ask, and when a result is expected back. It does not carry the
 * result, and this module cannot express one. That is the same call as the movement
 * log's missing `result` column (ADR-049) and `ClinicalStrip`'s missing `status`
 * prop (R2.3): the moment an app stores "scan — normal", it is keeping a clinical
 * finding, and the next feature that reads it is interpreting one.
 *
 * `results_due` is the exception that proves it: it is a **date**, and the most it
 * ever produces is "you were expecting to hear back by now" — a prompt to chase a
 * human, not a judgement about what they will say.
 */

import { diffDays } from "../calculators/dates.ts";

export type Appointment = {
  id: string;
  /** Free text — "Dr Mansour", "the midwife team", or nothing. */
  clinician: string | null;
  /** Free text rather than an enum: her vocabulary, not ours. */
  type: string | null;
  /** ISO timestamp. Null when she recorded one without a date yet. */
  datetime: string | null;
  /** Questions she wants to ask. The one field that reliably gets used. */
  prep: readonly string[];
  /** ISO date she was told to expect a result by. Never a result. */
  resultsDue: string | null;
};

/** How far past `results_due` before it is worth mentioning at all. */
const CHASE_AFTER_DAYS = 0;

const startOfDay = (iso: string) => iso.slice(0, 10);

/**
 * Split into what is ahead and what has happened, newest-first within each.
 *
 * An appointment with no date sorts into `upcoming`: she wrote it down because it
 * is going to happen, and burying it under last year's is the opposite of useful.
 */
export function splitAppointments(
  appointments: readonly Appointment[],
  todayISO: string,
): { upcoming: Appointment[]; past: Appointment[] } {
  const upcoming: Appointment[] = [];
  const past: Appointment[] = [];

  for (const appointment of appointments) {
    if (!appointment.datetime || startOfDay(appointment.datetime) >= todayISO) {
      upcoming.push(appointment);
    } else {
      past.push(appointment);
    }
  }

  // Soonest first when looking forward; most recent first when looking back. An
  // undated one leads, because it is the one still needing a date.
  upcoming.sort((a, b) => (a.datetime ?? "").localeCompare(b.datetime ?? ""));
  past.sort((a, b) => (b.datetime ?? "").localeCompare(a.datetime ?? ""));

  return { upcoming, past };
}

/** The one she is most likely to have opened the app about. */
export function nextAppointment(
  appointments: readonly Appointment[],
  todayISO: string,
): Appointment | null {
  return splitAppointments(appointments, todayISO).upcoming.find((a) => a.datetime) ?? null;
}

/** Whole days until it happens; negative once it has passed. Null when undated. */
export function daysUntil(appointment: Appointment, todayISO: string): number | null {
  if (!appointment.datetime) return null;
  return diffDays(todayISO, startOfDay(appointment.datetime));
}

/**
 * Results she was told to expect by a date that has now passed.
 *
 * The **only** thing this ever means is "it may be worth asking". It is not a
 * finding, not an alert and not a red flag: a result can be late for a dozen
 * ordinary reasons, and an app that made this feel urgent would be inventing
 * clinical significance out of a calendar.
 */
export function awaitingResults(
  appointments: readonly Appointment[],
  todayISO: string,
): Appointment[] {
  return appointments
    .filter((a) => a.resultsDue !== null && diffDays(a.resultsDue, todayISO) > CHASE_AFTER_DAYS)
    .sort((a, b) => (a.resultsDue ?? "").localeCompare(b.resultsDue ?? ""));
}

/**
 * Prep questions, cleaned. Blank lines dropped, order kept, duplicates kept —
 * she may genuinely want to ask the same thing twice and it is not our call.
 */
export function parsePrep(text: string): string[] {
  return text
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line.length > 0);
}
