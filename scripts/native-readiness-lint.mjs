#!/usr/bin/env node
/**
 * Client-component medical-logic guard (R2.7, ADR-060, `docs/24` §5).
 *
 * ## What this used to check, and why it stopped being true
 *
 * This file began as the P4.0 native-readiness ratchet: no `@/lib/supabase/server`,
 * no `force-dynamic`, no Server Actions, no `searchParams` in the tracker path,
 * because a Capacitor `output: "export"` build had to survive without a server and
 * the failure was silent — middleware does not error under export, it is disabled,
 * taking locale routing and session refresh with it.
 *
 * ADR-060 replaced Capacitor with Flutter and put the medical decisions on a
 * Supabase Edge Function. Under that architecture **the tracker is supposed to call
 * the server**, so the old rule did not merely expire — it started forbidding the
 * thing the design requires. `docs/24` §5 says so explicitly and names what should
 * be guarded instead:
 *
 * > **No medical decision logic inside a client component.** Thresholds, red-flag
 * > sets, persona rules, alert cadences and screener scoring live in tier 1 or
 * > tier 2 — never inline in a screen.
 *
 * That is the rule this file now enforces, with the same ratchet machinery and the
 * same "watch it fail before trusting it" discipline. The four old rules are gone,
 * not relaxed: their reason went with `output: "export"`, and a guard kept for
 * sentiment is a guard that teaches people to route around guards.
 *
 * ## Why these four checks and not a cleverer one
 *
 * A screen cannot be proved free of medical reasoning by a regex. What *can* be
 * checked is the shape the mistake takes, and each rule below is one that has a
 * correct home to point at:
 *
 *   1. `resolves-persona` — a component that resolves or composes the experience
 *      itself. This is the strongest of the four and the reason the file exists:
 *      it is exactly what `pregnancy-experience.tsx` and `postpartum-experience.tsx`
 *      did until R2.4, and while they did it the server and the browser disagreed
 *      about who a postpartum woman was.
 *   2. `medical-constant` — a threshold, red-flag set, cadence or scoring table
 *      declared in the file. `lib/pregnancy/movements.ts` is the pattern to copy:
 *      `MIN_SESSIONS_FOR_PATTERN` lives there and the counter imports it.
 *   3. `day-arithmetic` — milliseconds-per-day maths in a screen. Deriving
 *      gestational age or a cycle day a second time is how two clients come to
 *      disagree about a woman's health; `lib/calculators/dates.ts` owns it.
 *   4. `screener-scoring` — accumulating a score in a component. PHQ-9, GAD-7,
 *      DRSP and PBAC arrive with P2.7; their scoring is tier 1 before it is a
 *      screen.
 *
 * Persona and `mode ===` branching are guarded separately and better by
 * `persona-branch-lint`, and are deliberately not duplicated here.
 *
 * The ratchet: a NEW violation fails, and so does a STALE baseline entry, so the
 * list can only shrink and can never quietly over-claim. Never add to the baseline
 * to make the build pass — that is the drift this prevents.
 */
import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join } from "node:path";

const BASELINE_FILE = "scripts/native-readiness-baseline.json";

/**
 * Where the rule applies: everything a woman looks at. Staff tooling is excluded —
 * `/admin` renders aggregates for an operator, not a decision about anyone's care.
 */
const SCOPE = ["apps/web/src/components", "apps/web/src/app/[locale]/(app)"];
const EXCLUDE = [
  "apps/web/src/components/admin",
  "apps/web/src/app/[locale]/(app)/admin",
];

/**
 * Comments are documentation, not behaviour — the lesson `persona-branch-lint`
 * learned by tripping on its own explanation. Strings stay in: a red-flag list
 * written as string literals is still a red-flag list.
 */
function stripComments(text) {
  return text.replace(/\/\*[\s\S]*?\*\//g, "").replace(/(^|[^:])\/\/.*$/gm, "$1");
}

/** Tier-1 entry points. Importing one into a screen means the screen is deciding. */
const TIER1_CALLS = [
  "resolvePersona",
  "resolveForStatedTrack",
  "buildExperienceConfig",
  "registryOf",
  "signalsFromRows",
  "readSignals",
  "phaseFor",
  "phaseForTrack",
  "emotionalLayersFor",
  "PERSONA_RECORDS",
  "PERSONA_RULES",
  "findRecord",
];

/**
 * Names that mean "a medical decision is written down here".
 *
 * Two narrowings, both learned from watching the first version cry wolf on four
 * innocent files. It matches only **module-scope declarations of a literal** — a
 * table, a set or a number — because that is the shape a decision takes when it is
 * written into a screen; a `severityLabel` formatter and a `setSeverity` state
 * setter are neither. And it matches declarations only, never imports: pulling
 * `EMERGENCY_SYMPTOMS` in from `lib/pregnancy/symptoms` is the correct thing to do
 * and has to stay legal, since it is the fix this guard is asking for.
 */
const MEDICAL_CONSTANT =
  /^(?:export\s+)?(?:const|let|var)\s+([A-Za-z_$][\w$]*)\s*(?::[^=\n]+)?=\s*(?:[[{]|new\s+(?:Set|Map)\b|-?\d)/gm;

const MEDICAL_NOUN =
  /(RED_?FLAG|WARNING_?SIGN|EMERGENC|URGENC|URGENT|SEVERITY|TRIAGE|THRESHOLD|CUTOFF|NORMAL_RANGE|REFERENCE_RANGE|SCORING|_SCORE|SCORE_|CADENCE|DOSAGE|GESTATION|TRIMESTER|LUTEAL|FOLLICULAR|OVULATION|CYCLE_LENGTH|PERIOD_LENGTH)/i;

const RULES = [
  {
    id: "resolves-persona",
    test: (t) => new RegExp(`\\b(?:${TIER1_CALLS.join("|")})\\b`).test(t),
    why: "resolves or composes the experience itself — render the served `ExperienceConfig` instead (ADR-060)",
  },
  {
    id: "medical-constant",
    test: (t) => [...t.matchAll(MEDICAL_CONSTANT)].some(([, name]) => MEDICAL_NOUN.test(name)),
    why: "declares a medical threshold, red-flag set or scoring table — it belongs in lib/, where Dart can read it too",
  },
  {
    id: "day-arithmetic",
    test: (t) =>
      /86_?400_?000|1000\s*\*\s*60\s*\*\s*60\s*\*\s*24|24\s*\*\s*60\s*\*\s*60\s*\*\s*1000/.test(t),
    why: "derives days from milliseconds in a screen — lib/calculators/dates.ts owns that, once",
  },
  {
    id: "screener-scoring",
    test: (t) => /\bscore\s*\+=|\bscore\s*=\s*score\s*\+/i.test(t),
    why: "accumulates a screener score in a component — scoring is tier 1 (P2.7)",
  },
];

const norm = (p) => p.replaceAll("\\", "/");

function walk(dir, out = []) {
  if (!existsSync(dir)) return out;
  for (const entry of readdirSync(dir)) {
    const p = join(dir, entry);
    if (statSync(p).isDirectory()) walk(p, out);
    else if (/\.tsx?$/.test(p) && !/\.test\.tsx?$/.test(p)) out.push(norm(p));
  }
  return out;
}

const candidates = walk(SCOPE[0]).concat(...SCOPE.slice(1).map((d) => walk(d)));
/** Client components only — the rule as `docs/24` §5 states it. */
const files = candidates
  .filter((f) => !EXCLUDE.some((x) => f.startsWith(norm(x))))
  .filter((f) => /^\s*["']use client["']/m.test(readFileSync(f, "utf8")));

if (files.length === 0) {
  console.error("client-medical-logic: scanned 0 client components — the scope paths are wrong.");
  process.exit(1);
}

const found = new Set();
for (const file of files) {
  const text = stripComments(readFileSync(file, "utf8"));
  for (const rule of RULES) if (rule.test(text)) found.add(`${file}::${rule.id}`);
}

let baseline;
try {
  baseline = new Set(JSON.parse(readFileSync(BASELINE_FILE, "utf8")).violations);
} catch {
  console.error(`client-medical-logic: cannot read ${BASELINE_FILE}.`);
  process.exit(1);
}

const added = [...found].filter((v) => !baseline.has(v)).sort();
const stale = [...baseline].filter((v) => !found.has(v)).sort();
const why = (id) => RULES.find((r) => r.id === id).why;

if (added.length > 0) {
  console.error("\nclient-medical-logic FAILED — a screen is making a medical decision:\n");
  for (const v of added) {
    const [file, rule] = v.split("::");
    console.error(`  ${file}\n    ${rule}: ${why(rule)}`);
  }
  console.error(
    "\nThe backend owns decisions; the clients render them (ADR-060, docs/24 §1).",
    "\nMove it into lib/ — tier 1 if it is a decision, tier 2 if it is offline maths",
    "\nwith a golden fixture — and let the screen render the result.\n",
  );
}

if (stale.length > 0) {
  console.error("\nclient-medical-logic FAILED — baseline is stale; these no longer violate:\n");
  for (const v of stale) console.error(`  ${v}`);
  console.error(`\nRemove them from ${BASELINE_FILE} — the list must only shrink.\n`);
}

if (added.length > 0 || stale.length > 0) process.exit(1);

console.log(
  found.size === 0
    ? `client-medical-logic OK — ${files.length} client component(s) scanned, no medical logic inline.`
    : `client-medical-logic OK — ${files.length} client component(s) scanned, ` +
      `${found.size} baselined violation(s), no drift.`,
);
