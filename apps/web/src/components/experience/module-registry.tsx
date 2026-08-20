"use client";

import type { ReactNode } from "react";

import type { ExperienceConfig, ModuleId, ModuleSpec } from "@/lib/experience/types";
import { EmptyStrip } from "./clinical-strip";

/**
 * The module registry — where `ExperienceConfig` becomes pixels (R2.3, ADR-061).
 *
 * This is the indirection the whole revamp turns on. A screen used to say
 * `mode === "pregnancy"`; it now renders `config.home.modules` by **id**, so
 * telling D3 from D4 from D7 is a difference in *data*, not a new branch. Adding a
 * persona is a row in the registry; adding a module is an entry in this map.
 *
 * ## Unimplemented ids are visible, not silent
 *
 * The Track D registry declares more modules than are built. An unknown id renders
 * nothing — but `UNIMPLEMENTED` names them explicitly and a test asserts the two
 * sets together cover every id the registry can emit. A module that silently
 * vanished would be the worst failure available here: the engine would look
 * correct while a woman's screen quietly lost a panel.
 */

export type ModuleContext = {
  config: ExperienceConfig;
  /** Rendered for `pregnancy.week` — the existing hero, unchanged (ADR-041). */
  pregnancyHero: ReactNode;
  /** Rendered for `pregnancy.warningSigns` — unchanged red-flag panel. */
  warningSigns: ReactNode;
  /** Rendered for `quickLog` — the existing log CTA. */
  quickLog: ReactNode;
  /** Rendered for `pregnancy.movement` when the phase surfaces it. */
  movement: ReactNode;
  /** Rendered for `library` / reading lists. */
  reading: ReactNode;
  /**
   * Rendered for `pregnancy.appointments` (P2.2.3).
   *
   * Supplied by the screen rather than imported here, like every other module. The
   * first attempt imported the card directly — which reads better until you notice
   * it drags `next-intl`'s navigation helpers into this file's import graph, and
   * this file is imported by a *node* test suite that renders nothing. The pattern
   * was already right; breaking it cost a green suite.
   */
  appointments?: ReactNode;
  /** Rendered for `pregnancy.weight` (P2.2.3). */
  weight?: ReactNode;
  /** Rendered for `pregnancy.contractions`, surfaced from ~36 weeks (P2.2.3). */
  contractions?: ReactNode;
  /**
   * Rendered for `support.checkIn` — Track E's hero.
   *
   * It had **no renderer at all** until P2.7: `support.checkIn` sat in
   * `UNIMPLEMENTED` while `postpartum-experience` passed its hero card in as
   * `pregnancyHero`, an id Track E never emits. So the postpartum screen shipped
   * in R2.5 with no hero and nobody noticed, because the node existed and was
   * simply never asked for.
   */
  checkIn?: ReactNode;
  /** Rendered for `support.moodScreener` — the EPDS (P2.7, P1.26.3). */
  moodScreener?: ReactNode;
  moodSupport?: ReactNode;
  followupSchedule?: ReactNode;
  intrusiveThoughts?: ReactNode;
  /** Track A (R2.5c). A2's wide, explained window; A1 contributes none. */
  teenWindow?: ReactNode;
  teenReassurance?: ReactNode;
  /**
   * A2's "worth mentioning to a trusted adult" note. Separate from `warningSigns`
   * on purpose — that one is the danger surface, and this one must never be.
   */
  teenWorthMentioning?: ReactNode;
  teenPrivacy?: ReactNode;
  teenBody?: ReactNode;
  teenReadiness?: ReactNode;
  /**
   * Track B (R1.9a). Two nodes, not one with a flag — `cycle.window` predicts and
   * `cycle.variability` declines to, and which one a persona contributes is the
   * tier-1 decision about whether Femio will predict for her at all.
   */
  cycleWindow?: ReactNode;
  cycleVariability?: ReactNode;
  cyclePersonalNormal?: ReactNode;
  cyclePhase?: ReactNode;
  cycleChangeAwareness?: ReactNode;
  cycleFlowStrip?: ReactNode;
  menopauseLongTerm?: ReactNode;
  medications?: ReactNode;
  gsm?: ReactNode;
  /**
   * The hidden-but-reachable trio (R1.9b). Every B and F spec repeats the rule in
   * its §I, and until now it was true of the router and invisible on the screen.
   */
  /** Track C (R1.9c). */
  ttcWindow?: ReactNode;
  ttcLogSummary?: ReactNode;
  ttcWorkup?: ReactNode;
  ttcConditionContext?: ReactNode;
  /** Track F (R1.9e) — the last hand-written dashboard, now driven by the document. */
  menopauseSince?: ReactNode;
  menopausePmb?: ReactNode;
  menopauseMarker?: ReactNode;
  menopauseTrend?: ReactNode;
  menopauseSymptomStrip?: ReactNode;
  mrs?: ReactNode;
  explore?: ReactNode;
  visitPrep?: ReactNode;
  privacy?: ReactNode;
};

/**
 * Ids the engine can emit that have no component yet. Listed rather than left to
 * fall through, so the gap is a tracked number instead of a surprise.
 *
 * Each is real Phase-2 work: appointments (P2.2.3, the table has been unused since
 * v1), weight (P2.2.3), birth prep, contractions (P2.2.3), and the support and lab
 * modules that arrive with D2 and the labs surface.
 */
export const UNIMPLEMENTED: readonly ModuleId[] = [
  /**
   * E2's lactation surfaces (P2.3). A feeding log and a per-breast symptom log are
   * real features with a table behind them, not cards — `feeding` became a
   * `LogKind` in R2.10a and E2 offers it, so the engine can already ask for them;
   * what is missing is somewhere to write.
   */
  "support.feeding",
  "support.breastSymptoms",
  /**
   * E7's watch (R2.5f). The lab log and the mood screener side by side, with **no
   * phase interpretation** — PPT has described phases and Femio never says which
   * one she is in, because that is a clinician's call on labs. `strip.thyroid`
   * already renders beneath it, so E7 is not silent meanwhile.
   */
  "thyroid.watch",
  /**
   * Track D's remaining three. Each is a real surface rather than a card: the
   * milestone feed, birth preparation, and screening-appointment prep. D1's spine —
   * the week hero, warning signs, appointments, weight, contractions — has rendered
   * since R2.3, so what is listed here is addition, never a blank screen.
   */
  "pregnancy.milestone",
  "pregnancy.birthPrep",
  "pregnancy.screeningPrep",
  /**
   * E6's loss-aware hero and D2's reassurance card. Both are **tone made visible**,
   * and both are the hardest copy in the product to get right — E6 §A's register is
   * gentle, uncountable and never celebratory, and the postpartum screen already
   * swaps its hero's tone for `gentle` meanwhile, so a woman after a loss is not
   * currently seeing the wrong thing. She is seeing the neutral thing.
   */
  "support.lossAware",
  "support.reassurance",
];

/**
 * No reading recorded yet — the labs and glucose surfaces land with P2.2.3, so the
 * empty state is the honest one rather than a fabricated value. It still proves
 * the module was *chosen by the engine*, which is what R2.3 has to demonstrate:
 * D7 gets this and D3 does not, from data alone.
 */
const ThyroidStrip = () => <EmptyStrip titleKey="thyroid.title" ctaKey="thyroid.empty" />;
const GlucoseStrip = () => <EmptyStrip titleKey="glucose.title" ctaKey="glucose.empty" />;
/**
 * The remaining three (R1.9k). Same construction as the two above and the same
 * refusal: a strip is her own entries plus the lab's own reference range, and it
 * has no `status`, no `inRange` and no trend **by design** (D7 §G, R2.3). The
 * medicine strip says its two absences out loud — never a dose, never a score for
 * taking them — because P2.4 established both and a strip is where they would
 * quietly come back.
 */
const LabsStrip = () => <EmptyStrip titleKey="labs.title" ctaKey="labs.empty" />;
const MedicationStrip = () => <EmptyStrip titleKey="medication.title" ctaKey="medication.empty" />;
const DevicesStrip = () => <EmptyStrip titleKey="devices.title" ctaKey="devices.empty" />;

type Renderer = (ctx: ModuleContext, spec: ModuleSpec) => ReactNode;

const RENDERERS: Partial<Record<ModuleId, Renderer>> = {
  "teen.window": (ctx) => ctx.teenWindow,
  "teen.body": (ctx) => ctx.teenBody,
  "teen.readiness": (ctx) => ctx.teenReadiness,
  "cycle.window": (ctx) => ctx.cycleWindow,
  "cycle.variability": (ctx) => ctx.cycleVariability,
  "cycle.personalNormal": (ctx) => ctx.cyclePersonalNormal,
  "cycle.phase": (ctx) => ctx.cyclePhase,
  "cycle.changeAwareness": (ctx) => ctx.cycleChangeAwareness,
  "cycle.flowStrip": (ctx) => ctx.cycleFlowStrip,
  "menopause.longTerm": (ctx) => ctx.menopauseLongTerm,
  medications: (ctx) => ctx.medications,
  gsm: (ctx) => ctx.gsm,
  "ttc.window": (ctx) => ctx.ttcWindow,
  "ttc.logSummary": (ctx) => ctx.ttcLogSummary,
  "ttc.workup": (ctx) => ctx.ttcWorkup,
  "ttc.conditionContext": (ctx) => ctx.ttcConditionContext,
  "menopause.since": (ctx) => ctx.menopauseSince,
  "menopause.pmb": (ctx) => ctx.menopausePmb,
  "menopause.marker": (ctx) => ctx.menopauseMarker,
  "menopause.trend": (ctx) => ctx.menopauseTrend,
  "menopause.symptomStrip": (ctx) => ctx.menopauseSymptomStrip,
  mrs: (ctx) => ctx.mrs,
  explore: (ctx) => ctx.explore,
  visitPrep: (ctx) => ctx.visitPrep,
  privacy: (ctx) => ctx.privacy,
  "teen.reassurance": (ctx) => ctx.teenReassurance,
  "teen.worthMentioning": (ctx) => ctx.teenWorthMentioning,
  "teen.privacy": (ctx) => ctx.teenPrivacy,
  "pregnancy.week": (ctx) => ctx.pregnancyHero,
  "pregnancy.appointments": (ctx) => ctx.appointments,
  "pregnancy.weight": (ctx) => ctx.weight,
  "pregnancy.contractions": (ctx) => ctx.contractions,
  "support.checkIn": (ctx) => ctx.checkIn,
  "support.moodScreener": (ctx) => ctx.moodScreener,
  "support.moodSupport": (ctx) => ctx.moodSupport,
  "followup.schedule": (ctx) => ctx.followupSchedule,
  "support.intrusiveThoughts": (ctx) => ctx.intrusiveThoughts,
  "pregnancy.warningSigns": (ctx) => ctx.warningSigns,
  "pregnancy.movement": (ctx) => ctx.movement,
  quickLog: (ctx) => ctx.quickLog,
  library: (ctx) => ctx.reading,
  "strip.thyroid": () => <ThyroidStrip />,
  "strip.glucose": () => <GlucoseStrip />,
  "strip.labs": () => <LabsStrip />,
  "strip.medication": () => <MedicationStrip />,
  "strip.devices": () => <DevicesStrip />,
};

/** Every id this registry can render. Used by the coverage test. */
export const IMPLEMENTED = Object.keys(RENDERERS) as readonly ModuleId[];

export function ExperienceModules({ ctx }: { ctx: ModuleContext }) {
  return (
    <>
      {ctx.config.home.modules.map((spec) => {
        const render = RENDERERS[spec.id];
        if (!render) return null;
        return <div key={spec.id}>{render(ctx, spec)}</div>;
      })}
    </>
  );
}
