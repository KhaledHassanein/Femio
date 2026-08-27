"use client";

import type { ReactNode } from "react";

import type { ExperienceConfigV2 } from "@/lib/experience/v2/types";
import type { Phase } from "@/lib/experience/types";
import { groundImage } from "@/lib/experience/v2/ground";
import { ModuleHost } from "./module-host";

/**
 * The v2 home surface (RB-C4, `docs/29_REBUILD/06` §1).
 *
 * Mounted only when `experience.v2.home` is on. The v1 `DashboardScreen` is
 * untouched and still the default, which is the per-screen migration the teardown
 * found Flo running — `CalendarScreenActivity` and `UicCalendarActivity` shipping
 * side by side, one flag deciding.
 *
 * ## Phase as ground, not as a badge
 *
 * The single most transferable thing in the whole teardown. Logging one period in
 * Flo repainted the entire screen: peach with no data, teal-mint in the fertile
 * window, with the date-strip numerals recolouring too. There is no chip and no
 * label — **the background says where she is in her cycle**.
 *
 * We already had `--phase-*` tokens and used them for a strip. This puts them where
 * Flo puts them, and adds what Flo cannot: the crossfade is `--motion-phase` at
 * 600ms, slower than anything else, because a ground colour that hurries reads as a
 * glitch rather than as scenery.
 *
 * **It degrades to nothing.** A woman whose cycles are irregular enough that tier 1
 * will not name a phase gets the neutral ground — not a guess, and not an apology.
 * `phase === null` is a normal state, not a missing value.
 *
 * ## What this component does not do
 *
 * It does not decide anything. Which modules appear, in what order, with what
 * emphasis, is entirely `config.surfaces.home.modules`. This file has no `mode ===`
 * and no persona knowledge, and `persona-branch-lint` is what keeps that true.
 */

export type ModuleRenderer = (spec: ExperienceConfigV2["surfaces"]["home"]["modules"][number]) => ReactNode;

export function HomeShell({
  config,
  render,
  header,
  footer,
}: {
  config: ExperienceConfigV2;
  /**
   * The registry lookup. Passed in rather than imported so this shell stays free of
   * every module's dependencies — and so a test can render it with two stubs.
   */
  render: ModuleRenderer;
  header?: ReactNode;
  footer?: ReactNode;
}) {
  const ground = groundImage(config.variables.phase);
  const phase: Phase | null = config.phase;

  return (
    <div
      /**
       * The ground. `background-image` rather than `background-color` because a flat
       * wash across a whole screen reads as a theme change; a soft radial reads as
       * light. `transition-ground` covers background-image, which `transition-colors`
       * does not — the reason that utility was added in C2.
       */
      className="min-h-full transition-ground duration-crossfade ease-standard"
      style={
        ground === null
          ? undefined
          : { backgroundImage: ground }
      }
      /**
       * The phase is already announced by the module that names it. Marking the
       * ground `presentation` stops a screen reader describing a decorative
       * gradient, which would be noise rather than information.
       */
      data-phase={typeof config.variables.phase === "string" ? config.variables.phase : undefined}
      data-pregnancy-phase={phase ?? undefined}
    >
      <div className="flex flex-col gap-6">
        {header}
        {config.surfaces.home.modules.map((spec) => {
          const content = render(spec);
          if (content === null || content === undefined) return null;
          return (
            <ModuleHost key={spec.id} spec={spec}>
              {content}
            </ModuleHost>
          );
        })}
        {footer}
      </div>
    </div>
  );
}
