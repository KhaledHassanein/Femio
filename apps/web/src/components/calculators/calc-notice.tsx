"use client";

import { useEffect, useState, type ReactNode } from "react";
import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { todayISO } from "@/lib/calculators/dates";

/**
 * Her local date, after mount. The server renders in UTC and does not know her
 * timezone, so "today" is empty on the server pass and every check that needs it
 * waits for the client (no hydration mismatch, no off-by-one in the evening).
 */
export function useToday(): string {
  const [today, setToday] = useState("");
  useEffect(() => setToday(todayISO()), []);
  return today;
}

const READ = {
  irregular: { href: "/learn/irregular-cycles-and-timing", key: "readIrregular" },
  test: { href: "/learn/when-to-take-pregnancy-test", key: "readLate" },
  normal: { href: "/learn/is-my-period-normal", key: "readNormal" },
} as const;

/**
 * Why a calculator is not showing a result, or what to read alongside it. Every
 * input the maths cannot use gets one of these instead of a silent change of value
 * or a result that quietly disappears (public audit F02, F15, F16).
 */
export function CalcNotice({
  children,
  read = [],
}: {
  children: ReactNode;
  read?: (keyof typeof READ)[];
}) {
  const t = useTranslations("calculators.issues");
  return (
    <div className="flex flex-col gap-2 rounded-sm bg-warning-soft p-4 text-sm text-warning-text">
      <p>{children}</p>
      {read.length ? (
        <ul className="flex flex-col gap-1">
          {read.map((r) => (
            <li key={r}>
              <Link href={READ[r].href} className="font-semibold underline underline-offset-4">
                {t(READ[r].key)}
              </Link>
            </li>
          ))}
        </ul>
      ) : null}
    </div>
  );
}

/** One polite live region per tool, so a screen reader hears the settled result (F29). */
export function ResultRegion({ children }: { children: ReactNode }) {
  return (
    <div aria-live="polite" className="flex flex-col gap-4">
      {children}
    </div>
  );
}
