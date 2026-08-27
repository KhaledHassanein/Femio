"use client";

import { useEffect, useRef, type ReactNode } from "react";
import { useTranslations } from "next-intl";

import { withoutModulesPrefix } from "@/lib/experience/v2/ground";
import type { ModuleSpecV2, MotionToken } from "@/lib/experience/v2/types";

/**
 * The wrapper every v2 module renders inside (RB-C4, `docs/29_REBUILD/06` §1).
 *
 * ## What it is for
 *
 * v2 made `a11y` required on `ModuleSpec` so a served module cannot ship
 * unlabelled. That is a promise the *type* makes; this is the component that keeps
 * it. Every module goes through here, so the accessible name is applied in one
 * place rather than remembered in fifty.
 *
 * The same argument covers `visibility` and `measure`: motion and first-party
 * measurement are declared on the module and applied here, so a module author
 * writes neither and cannot get either wrong.
 *
 * ## Why the module itself receives no a11y props
 *
 * A module that had to apply its own `aria-label` could forget, and forgetting
 * would look identical to succeeding. Hoisting it removes the possibility rather
 * than documenting the requirement — the same reasoning as `a11y` being required
 * in the type at all.
 */

/** `MotionToken` → the CSS custom property C2 added. */
const MOTION: Record<Exclude<MotionToken, "none">, string> = {
  instant: "var(--motion-instant)",
  quick: "var(--motion-quick)",
  standard: "var(--motion-standard)",
  deliberate: "var(--motion-deliberate)",
};

function enterDuration(token: MotionToken | undefined): string | undefined {
  if (token === undefined || token === "none") return undefined;
  return MOTION[token];
}

export function ModuleHost({
  spec,
  children,
  className,
}: {
  spec: ModuleSpecV2;
  children: ReactNode;
  className?: string;
}) {
  /**
   * A served document carries the **full** key — `modules.cycle.window.label` —
   * because it must be self-describing to the Dart client too, which has no
   * next-intl namespace concept. `useTranslations` needs a literal namespace
   * (`i18n-client-lint` enforces it, so a namespace can be traced to the bundle it
   * ships in), so the prefix is stripped here. One line, in one place.
   */
  const t = useTranslations("modules");
  const key = withoutModulesPrefix;
  const ref = useRef<HTMLElement | null>(null);
  const fired = useRef(false);

  /**
   * First-party visibility measurement (`MeasureSpec`).
   *
   * Deliberately does nothing yet beyond observing. There is no sink until the
   * first-party aggregate store exists, and writing to `lib/insights` from here
   * before its k-anonymity threshold is wired would be the exact mistake product
   * rule 4 exists to prevent. The observer is here so the contract is honoured the
   * day the sink lands, and `fired` guarantees once-per-mount either way.
   */
  useEffect(() => {
    const el = ref.current;
    const measure = spec.measure;
    if (el === null || measure === undefined || typeof IntersectionObserver === "undefined") return;

    const minMs = measure.minVisibleMs ?? 1000;
    const minRatio = measure.minVisibleRatio ?? 0.5;
    let timer: ReturnType<typeof setTimeout> | undefined;

    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.intersectionRatio >= minRatio && !fired.current) {
            timer = setTimeout(() => {
              fired.current = true;
              // Sink lands with the first-party aggregate store. See above.
            }, minMs);
          } else if (timer !== undefined) {
            clearTimeout(timer);
            timer = undefined;
          }
        }
      },
      { threshold: [minRatio] },
    );
    observer.observe(el);
    return () => {
      observer.disconnect();
      if (timer !== undefined) clearTimeout(timer);
    };
  }, [spec.measure]);

  const duration = enterDuration(spec.visibility?.enter);

  return (
    <section
      ref={ref}
      className={className}
      /**
       * `role` is only set when the document asks for something other than the
       * implicit `region`, because an explicit `role="region"` on a `<section>`
       * with a label is redundant and some screen readers announce it twice.
       */
      {...(spec.a11y.role !== undefined && spec.a11y.role !== "region"
        ? { role: spec.a11y.role }
        : {})}
      aria-label={t(key(spec.a11y.labelKey))}
      {...(spec.a11y.descriptionKey !== undefined
        ? { "aria-description": t(key(spec.a11y.descriptionKey)) }
        : {})}
      {...(spec.a11y.liveRegion !== undefined ? { "aria-live": spec.a11y.liveRegion } : {})}
      style={
        duration === undefined
          ? undefined
          : /**
             * `motion-safe` is not available here because the value is dynamic, but
             * globals.css clamps every transition to 0.01ms under
             * prefers-reduced-motion, so this is already respected.
             */
            { transition: `opacity ${duration} var(--ease-out)` }
      }
    >
      {children}
    </section>
  );
}
