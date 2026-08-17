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
  /** Track A (R2.5c). A2's wide, explained window; A1 contributes none. */
  teenWindow?: ReactNode;
  teenReassurance?: ReactNode;
  /**
   * A2's "worth mentioning to a trusted adult" note. Separate from `warningSigns`
   * on purpose — that one is the danger surface, and this one must never be.
   */
  teenWorthMentioning?: ReactNode;
  teenPrivacy?: ReactNode;
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
   * Track A's two content hubs (R2.5c). Both are *articles*, not components —
   * "what's changing in my body" and the first-period readiness plan — and no teen
   * content exists in the CMS yet. Listed rather than silently dropped so the gap
   * is a number someone can count, and so the day the content lands the module is
   * already in the registry waiting for it (P2.13).
   */
  "teen.body",
  "teen.readiness",
  /**
   * Track B's surfaces (R2.8). The registry is **data only**, exactly as R2.1 was
   * for Track D: it is what makes a woman's cycle experience come from her record
   * rather than from `mode === "cycle"`, and every part of the document that needs
   * no component — her tone, her alerts, her EMR view and her reading list — is
   * live the day it ships. What is listed here is the panel each module will
   * eventually draw, designed and argued in
   * `assets/mockups/R1.5_cycle_dashboard_reference.html` and implemented under R1.9.
   *
   * `cycle.window` and `cycle.variability` are two ids rather than one with a flag,
   * and that distinction has to survive into the components: one predicts, the
   * other declines to, and collapsing them is how the invented-window defect would
   * come back at a fourth life stage.
   */
  "cycle.window",
  "cycle.variability",
  "cycle.phase",
  "cycle.flowStrip",
  "cycle.personalNormal",
  "cycle.changeAwareness",
  "explore",
  "visitPrep",
  "privacy",
  /**
   * Track F's surfaces (R2.9), data-only for the same reason Track B's are. Two
   * of them already exist as components on the shipped menopause panel —
   * `MrsCheck` and the months-since hero — and wiring them through the registry
   * is R1.9's work rather than a second copy here. `menopause.pmb` is the one to
   * build first when that lands: it is the only danger surface in the track, and
   * the record now reaches a woman who logs a bleed after twelve months, which it
   * could not before this change.
   */
  "menopause.trend",
  "menopause.since",
  "menopause.marker",
  "menopause.symptomStrip",
  "menopause.longTerm",
  "menopause.pmb",
  "mrs",
  "medications",
  "gsm",
  /**
   * E2's lactation surfaces (P2.3). The feeding log and the per-breast symptom
   * log are real Phase-2 features and the content behind them — "the first two
   * weeks", "if breastfeeding is not working" — is in the approved postpartum
   * batch (P2.3c) and not yet drafted. Listed so the gap is counted.
   */
  "support.feeding",
  "support.breastSymptoms",
  /**
   * E3, E4 and E7's surfaces (R2.5f). The records exist so that a woman who told
   * the postpartum triage about her mood, her gestational diabetes or her thyroid
   * gets the right *tone, alerts, EMR view and reading list* today — those parts
   * of the document need no component. What is listed here is the panel each
   * persona will eventually add on top of E1's spine, and E1's spine still renders
   * in full underneath, so the degradation is a missing addition rather than a
   * blank screen. `followup.schedule` in particular is a real feature: the 4–12
   * week OGTT and the 72-hour and 7–10-day blood-pressure checks are the follow-up
   * E4 §A says routine care drops, and a reminder surface for them is P2.4b.
   */
  "support.moodSupport",
  "support.intrusiveThoughts",
  "followup.schedule",
  "thyroid.watch",
  "pregnancy.milestone",
  "pregnancy.birthPrep",
  "pregnancy.screeningPrep",
  "strip.labs",
  "strip.medication",
  "strip.devices",
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

type Renderer = (ctx: ModuleContext, spec: ModuleSpec) => ReactNode;

const RENDERERS: Partial<Record<ModuleId, Renderer>> = {
  "teen.window": (ctx) => ctx.teenWindow,
  "teen.reassurance": (ctx) => ctx.teenReassurance,
  "teen.worthMentioning": (ctx) => ctx.teenWorthMentioning,
  "teen.privacy": (ctx) => ctx.teenPrivacy,
  "pregnancy.week": (ctx) => ctx.pregnancyHero,
  "pregnancy.appointments": (ctx) => ctx.appointments,
  "pregnancy.weight": (ctx) => ctx.weight,
  "pregnancy.contractions": (ctx) => ctx.contractions,
  "support.checkIn": (ctx) => ctx.checkIn,
  "support.moodScreener": (ctx) => ctx.moodScreener,
  "pregnancy.warningSigns": (ctx) => ctx.warningSigns,
  "pregnancy.movement": (ctx) => ctx.movement,
  quickLog: (ctx) => ctx.quickLog,
  library: (ctx) => ctx.reading,
  "strip.thyroid": () => <ThyroidStrip />,
  "strip.glucose": () => <GlucoseStrip />,
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
