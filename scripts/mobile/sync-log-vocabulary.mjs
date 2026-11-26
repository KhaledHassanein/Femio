#!/usr/bin/env node --experimental-strip-types
/**
 * Give the Android app the website's log vocabulary and its translations (P3.4).
 *
 * `apps/web/src/lib/log-vocabulary/vocabulary.ts` is the canonical list of what can be
 * logged (RB-B3), and the web catalogues already carry every label in four reviewed
 * languages. A second hand-written list in Dart is how the app would end up with a
 * symptom the website does not know, or "Hot flushes" in one place and "Hot flashes"
 * in the other. So the app's list and labels are generated from those two sources:
 *
 *   apps/mobile/lib/domain/log_vocabulary.g.dart   the terms (key, dimension, sensitivity)
 *   apps/mobile/lib/l10n/log_labels.g.dart         key → localised label
 *   apps/mobile/lib/l10n/app_{en,ar,fr,es}.arb     the `log*` and `flow*` entries
 *
 * Vitals are left out: the app does not take measurements yet.
 *
 *   node --experimental-strip-types scripts/mobile/sync-log-vocabulary.mjs          write
 *   node --experimental-strip-types scripts/mobile/sync-log-vocabulary.mjs --check  gate
 */
import { readFileSync, writeFileSync } from "node:fs";

const { LOG_TERMS } = await import("../../apps/web/src/lib/log-vocabulary/vocabulary.ts");

const LOCALES = ["en", "ar", "fr", "es"];
const DIMENSIONS = ["mood", "symptom", "discharge", "intercourse"];
const FLOW = ["spotting", "light", "medium", "heavy"];
const OPK = ["negative", "low", "high", "peak", "positive"];

/** Whole strings the app takes from the web catalogues verbatim (arb key → web path). */
const SHARED = {
  bbtChartHeading: "fertility.chart.heading",
  bbtChartNeedData: "fertility.chart.needData",
  bbtChartNote: "fertility.chart.note",
  invalidBbt: "fertility.invalidBbt",
  testTimingGeneral: "calculators.pregnancyTest.notePeriod",
  // MR-21 / CLIN-8: when her next period cannot be named, the NHS 21-day rule.
  testTimingUnknown: "calculators.pregnancyTest.noteSex",
  testTimingSource: "calculators.pregnancyTest.source",
  // Pregnancy (P3.6): the website's reviewed contraction timer, movement log and
  // red-flag wording, so the app says exactly what the clinician-reviewed site says.
  pregDaysToGo: "pregnancy.daysToGo",
  pregOverdue: "pregnancy.overdue",
  pregTermFrom: "pregnancy.termFrom",
  pregEstimateNote: "pregnancy.estimateNote",
  pregRedFlagsHeading: "pregnancy.redFlags.heading",
  // MR-29: the sourced sentence (ACOG, CDC Hear Her) the gestational-age calculator shows,
  // not the older unsourced list; the app card and screen must say exactly this.
  pregRedFlagsBody: "calculators.rules.redFlag",
  redFlagsReadGuide: "pregnancy.redFlags.link",
  contractionsHeading: "contractions.heading",
  contractionsIntro: "contractions.intro",
  contractionsStart: "contractions.start",
  contractionsStop: "contractions.stop",
  contractionsRunning: "contractions.running",
  contractionsContactHeading: "contractions.contact.heading",
  contractionsContactBody: "contractions.contact.body",
  contractionsSummaryHeading: "contractions.summary.heading",
  contractionsSummaryDuration: "contractions.summary.duration",
  contractionsSummaryInterval: "contractions.summary.interval",
  contractionsSummaryNote: "contractions.summary.note",
  movementsHeading: "pregnancyMovements.heading",
  movementsIntro: "pregnancyMovements.intro",
  movementsUrgentHeading: "pregnancyMovements.urgent.heading",
  movementsUrgentBody: "pregnancyMovements.urgent.body",
  movementsStart: "pregnancyMovements.start",
  movementsStartBody: "pregnancyMovements.startBody",
  movementsTap: "pregnancyMovements.tap",
  movementsCounted: "pregnancyMovements.counted",
  movementsFinish: "pregnancyMovements.finish",
  movementsFinishNote: "pregnancyMovements.finishNote",
  movementsRecentHeading: "pregnancyMovements.recentHeading",
  movementsSessionSummary: "pregnancyMovements.sessionSummary",
  movementsUnfinished: "pregnancyMovements.unfinished",
  movementsSlowerHeading: "pregnancyMovements.pattern.slowerHeading",
  movementsSlowerBody: "pregnancyMovements.pattern.slowerBody",
  movementsNeedMore: "pregnancyMovements.pattern.needMore",
  apptTitle: "appointments.title",
  apptAdd: "appointments.add",
  apptCancel: "appointments.cancel",
  apptSave: "appointments.save",
  apptUntitled: "appointments.untitled",
  apptNoDate: "appointments.noDate",
  apptToday: "appointments.todayLabel",
  apptInDays: "appointments.inDays",
  apptPrepHeading: "appointments.prepHeading",
  apptUpcoming: "appointments.upcomingHeading",
  apptPast: "appointments.pastHeading",
  apptNoResultsNote: "appointments.noResultsNote",
  apptEmptyHeading: "appointments.empty.heading",
  apptEmptyBody: "appointments.empty.body",
  apptAwaitingHeading: "appointments.awaiting.heading",
  apptAwaitingBody: "appointments.awaiting.body",
  apptFormType: "appointments.form.type",
  apptFormTypePlaceholder: "appointments.form.typePlaceholder",
  apptFormClinician: "appointments.form.clinician",
  apptFormWhen: "appointments.form.datetime",
  apptFormResultsDue: "appointments.form.resultsDue",
  apptFormResultsDueHint: "appointments.form.resultsDueHint",
  apptFormPrep: "appointments.form.prep",
  apptFormPrepPlaceholder: "appointments.form.prepPlaceholder",
  apptPrepCount: "appointments.card.prepCount",
  weightHeading: "weight.heading",
  weightIntro: "weight.intro",
  weightValue: "weight.value",
  weightSave: "weight.save",
  weightInvalid: "weight.invalid",
  weightNeedData: "weight.needData",
  weightChange: "weight.change",
  weightNote: "weight.note",
  weightDate: "weight.date",
  weightUnitKg: "weight.units.kg",
  weightUnitLb: "weight.units.lb",
};

const terms = LOG_TERMS.filter((t) => DIMENSIONS.includes(t.dimension));
const camel = (s) => s.charAt(0).toUpperCase() + s.slice(1);
const arbKey = (key) => `log${camel(key)}`;

function lookup(messages, path) {
  const value = path.split(".").reduce((o, k) => (o == null ? undefined : o[k]), messages);
  if (typeof value !== "string") throw new Error(`missing web string ${path}`);
  return value;
}

/**
 * A web catalogue string as an ARB entry. Simple `{name}` placeholders are typed
 * String; an ICU `{name, plural, …}` is kept (both next-intl and gen-l10n read it),
 * its count typed int, and `#` spelled `{name}` because gen-l10n does not expand it.
 */
function toArb(value, path) {
  const placeholders = {};
  let text = "";
  for (let i = 0; i < value.length; ) {
    const m = /^\{(\w+)\s*,\s*(\w+)\s*,/.exec(value.slice(i));
    if (m) {
      if (m[2] !== "plural") throw new Error(`${path}: ICU ${m[2]} is not supported; port it by hand`);
      let depth = 0;
      let j = i;
      for (; j < value.length; j++) {
        if (value[j] === "{") depth++;
        else if (value[j] === "}" && --depth === 0) break;
      }
      placeholders[m[1]] = { type: "int" };
      text += value.slice(i, j + 1).replaceAll("#", `{${m[1]}}`);
      i = j + 1;
      continue;
    }
    const s = /^\{(\w+)\}/.exec(value.slice(i));
    if (s) {
      placeholders[s[1]] ??= { type: "String" };
      text += s[0];
      i += s[0].length;
      continue;
    }
    text += value[i++];
  }
  return { text, placeholders };
}

const outputs = new Map();

outputs.set(
  "apps/mobile/lib/domain/log_vocabulary.g.dart",
  [
    "// GENERATED by scripts/mobile/sync-log-vocabulary.mjs from",
    "// apps/web/src/lib/log-vocabulary/vocabulary.ts. Do not edit.",
    "",
    "enum LogDimension { mood, symptom, discharge, intercourse }",
    "",
    "class LogTerm {",
    "  const LogTerm(this.key, this.dimension, {this.elevated = false});",
    "  final String key;",
    "  final LogDimension dimension;",
    "",
    "  /// Not shown at a glance on a shared screen (vocabulary.ts `sensitivity`).",
    "  final bool elevated;",
    "}",
    "",
    "const logTerms = <LogTerm>[",
    ...terms.map(
      (t) =>
        `  LogTerm('${t.key}', LogDimension.${t.dimension}${t.sensitivity === "elevated" ? ", elevated: true" : ""}),`,
    ),
    "];",
    "",
    `const flowLevels = <String>[${FLOW.map((f) => `'${f}'`).join(", ")}];`,
    "",
    "/// What the ovulation-test stick said: her reading, never Femio's conclusion.",
    `const opkResults = <String>[${OPK.map((f) => `'${f}'`).join(", ")}];`,
    "",
  ].join("\n"),
);

outputs.set(
  "apps/mobile/lib/l10n/log_labels.g.dart",
  [
    "// GENERATED by scripts/mobile/sync-log-vocabulary.mjs. Do not edit.",
    "",
    "import 'app_localizations.dart';",
    "",
    "/// The localised label for a log term key.",
    "String logLabel(L10n l, String key) => switch (key) {",
    ...terms.map((t) => `      '${t.key}' => l.${arbKey(t.key)},`),
    "      _ => key,",
    "    };",
    "",
    "/// The localised label for an ovulation-test result.",
    "String opkLabel(L10n l, String result) => switch (result) {",
    ...OPK.map((f) => `      '${f}' => l.opk${camel(f)},`),
    "      _ => result,",
    "    };",
    "",
    "/// The localised label for a flow level.",
    "String flowLabel(L10n l, String level) => switch (level) {",
    ...FLOW.map((f) => `      '${f}' => l.flow${camel(f)},`),
    "      _ => level,",
    "    };",
    "",
  ].join("\n"),
);

for (const locale of LOCALES) {
  const web = JSON.parse(readFileSync(`apps/web/messages/${locale}.json`, "utf8"));
  const path = `apps/mobile/lib/l10n/app_${locale}.arb`;
  const arb = JSON.parse(readFileSync(path, "utf8"));
  for (const t of terms) arb[arbKey(t.key)] = lookup(web, t.labelKey);
  for (const f of FLOW) arb[`flow${camel(f)}`] = lookup(web, `track.flow.${f}`);
  arb.flowLabel = lookup(web, "track.flow.label");
  for (const o of OPK) arb[`opk${camel(o)}`] = lookup(web, `fertility.opk.${o}`);
  for (const [key, path] of Object.entries(SHARED)) {
    const { text, placeholders } = toArb(lookup(web, path), path);
    arb[key] = text;
    // The English file is gen-l10n's template: placeholders are declared there.
    if (locale === "en" && Object.keys(placeholders).length) arb[`@${key}`] = { placeholders };
  }
  outputs.set(path, `${JSON.stringify(arb, null, 2)}`);
}

const check = process.argv.includes("--check");
let stale = [];
for (const [path, content] of outputs) {
  let current = "";
  try {
    current = readFileSync(path, "utf8");
  } catch {}
  if (current !== content) {
    if (check) stale.push(path);
    else writeFileSync(path, content);
  }
}
if (check) {
  if (stale.length) {
    console.error(
      `✗ The app's log vocabulary is stale:\n  ${stale.join("\n  ")}\n` +
        "  Run `node --experimental-strip-types scripts/mobile/sync-log-vocabulary.mjs`.",
    );
    process.exit(1);
  }
  console.log(`✓ App log vocabulary matches the web (${terms.length} terms, 4 locales).`);
} else {
  console.log(`synced ${terms.length} terms into the app (4 locales)`);
}
