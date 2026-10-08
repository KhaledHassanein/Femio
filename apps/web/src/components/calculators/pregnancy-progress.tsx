"use client";

import { useTranslations } from "next-intl";
import { trimesterOf } from "@/lib/calculators";

const SEGMENTS = [
  { weeks: 14, className: "bg-phase-follicular" },
  { weeks: 14, className: "bg-phase-ovulatory" },
  { weeks: 12, className: "bg-phase-luteal" },
] as const;
const TERM = 40;

/** Where she is in 40 weeks, by trimester (ACOG boundaries, `trimesterOf`). */
export function PregnancyProgress({ weeks }: { weeks: number }) {
  const t = useTranslations("calculators.progress");
  const at = Math.min(TERM, Math.max(0, weeks));
  return (
    <div className="flex flex-col gap-2">
      <div className="flex items-baseline justify-between text-xs text-text-muted">
        <span>{t("weekOf", { week: Math.floor(at) })}</span>
        <span className="font-semibold text-text">{t("trimester", { n: trimesterOf(at) })}</span>
      </div>
      <div aria-hidden className="relative">
        <div className="flex h-3 w-full gap-0.5 overflow-hidden rounded-pill">
          {SEGMENTS.map((s, i) => (
            <span
              key={i}
              className={`${s.className} opacity-90`}
              style={{ width: `${(s.weeks / TERM) * 100}%` }}
            />
          ))}
        </div>
        <span
          className="absolute -top-1 size-5 -translate-x-1/2 rounded-round border-[3px] border-bg bg-text shadow rtl:translate-x-1/2"
          style={{ insetInlineStart: `${(at / TERM) * 100}%` }}
        />
      </div>
    </div>
  );
}
