"use client";

import { useEffect, useRef } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { chipVariants } from "@/components/ui/chip";
import { cn } from "@/lib/utils";

/**
 * The row of month chips above a pregnancy calendar (02_DESIGN_SPEC §2.3): a jump
 * to the month her last period fell in, without a dropdown. Oldest month first at
 * the inline start, so in Arabic it runs right to left like the rest of the page.
 *
 * Why it scrolls itself: ten chips are wider than a 390px screen, and the month she
 * most likely needs is the current one at the inline end, so the viewed chip is
 * centred on mount and whenever the viewed month changes. The offset is measured
 * from bounding boxes instead of `scrollLeft` because browsers disagree on the sign
 * of `scrollLeft` in right-to-left containers.
 */
export function MonthStrip({
  months,
  viewed,
  onSelect,
}: {
  /** Month-start ISO dates, oldest first. */
  months: readonly string[];
  /** Month-start ISO date currently shown in the grid. */
  viewed: string;
  onSelect: (monthISO: string) => void;
}) {
  const t = useTranslations("calculators.calendar");
  const format = useFormatter();
  const scroller = useRef<HTMLUListElement>(null);

  useEffect(() => {
    const box = scroller.current;
    const chip = box?.querySelector<HTMLElement>('[aria-pressed="true"]');
    if (!box || !chip) return;
    const b = box.getBoundingClientRect();
    const c = chip.getBoundingClientRect();
    box.scrollBy({ left: c.left + c.width / 2 - (b.left + b.width / 2), behavior: "auto" });
  }, [viewed]);

  const at = (iso: string) => new Date(`${iso}T00:00:00Z`);

  return (
    <nav aria-label={t("monthStrip")}>
      <ul
        ref={scroller}
        className="-mx-4 flex gap-2 overflow-x-auto px-4 py-1 [scrollbar-width:none] sm:mx-0 sm:px-0 [&::-webkit-scrollbar]:hidden"
      >
        {months.map((month) => {
          const selected = month === viewed;
          // The year is shown where it changes (the first chip and every January), so the
          // strip never reads as two chips for the same month name.
          const showYear = month === months[0] || month.slice(5, 7) === "01";
          return (
            <li key={month} className="shrink-0">
              <button
                type="button"
                aria-pressed={selected}
                aria-label={format.dateTime(at(month), { month: "long", year: "numeric", timeZone: "UTC" })}
                onClick={() => onSelect(month)}
                className={cn(chipVariants({ selected }), "focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-primary/50")}
              >
                {format.dateTime(at(month), { month: "short", timeZone: "UTC" })}
                {showYear ? (
                  <span className="ms-1 text-2xs text-text-muted">
                    {format.dateTime(at(month), { year: "2-digit", timeZone: "UTC" })}
                  </span>
                ) : null}
              </button>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
