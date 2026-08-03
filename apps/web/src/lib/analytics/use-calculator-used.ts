"use client";

import { useEffect, useRef } from "react";
import { useLocale } from "next-intl";
import { track } from "./track";
import type { Locale } from "@/i18n/routing";

/**
 * Reports that a public calculator produced a result — **once per page visit**
 * (P1.20.4).
 *
 * Once, not per keystroke: every calculator recomputes on each input change, so
 * firing on `hasResult` alone would send an event per character typed and turn a
 * usage count into a typing-speed measurement.
 *
 * Note what is *not* sent: which calculator. "Used the due-date calculator"
 * implies pregnancy and "used the fertile-window calculator" implies trying to
 * conceive — both health inferences about a person, so the catalog has no field
 * for them (ADR-017). Per-tool demand is a first-party question instead (ADR-020).
 */
export function useCalculatorUsed(hasResult: boolean) {
  const locale = useLocale() as Locale;
  const sent = useRef(false);

  useEffect(() => {
    if (!hasResult || sent.current) return;
    sent.current = true;
    void track("calculator_used", { locale });
  }, [hasResult, locale]);
}
