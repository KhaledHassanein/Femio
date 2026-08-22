"use client";

import {
  Baby,
  CalendarClock,
  ClipboardList,
  Calculator,
  Share2,
  FileText,
  HeartPulse,
  Pill,
  Thermometer,
} from "lucide-react";
import { useTranslations } from "next-intl";

import { Card } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";
import { AppScreen } from "@/components/patterns/app-screen";

/**
 * Everything Femio can do, in one place (`docs/27` phase 2.3).
 *
 * Five routes — `/summary`, `/fertility`, `/appointments`, `/screeners`,
 * `/medications` — were built, worked, and were **unreachable from the
 * navigation** (`docs/26` §2.3). The app was bigger than its own nav admitted,
 * which is the worst of both worlds: the work existed and she could not find it.
 *
 * ## Why this is one flat list and not a personalised one
 *
 * Product rule 2 is "personalize, never restrict". The dashboard is where her
 * stage decides what leads; **this screen is the promise that nothing was taken
 * away**. So it does not filter by persona, does not reorder by track, and does
 * not hide a tool because Femio thinks she will not want it — a woman who has told
 * us she is pregnant may still want the cycle-length calculator, and deciding
 * otherwise on her behalf is exactly the restriction the rule forbids.
 *
 * That also makes it the natural home for the "everything else is still here"
 * promise the dashboard used to spend its largest card explaining (R3.1.8). The
 * claim is better kept than described.
 */

type Tool = {
  href: string;
  key: string;
  Icon: typeof FileText;
};

/** In-app tools: her own record and the things that read it. */
const RECORD: readonly Tool[] = [
  { href: "/summary", key: "summary", Icon: FileText },
  { href: "/track", key: "track", Icon: CalendarClock },
  { href: "/medications", key: "medications", Icon: Pill },
  { href: "/appointments", key: "appointments", Icon: ClipboardList },
  /**
   * Partner sharing (Phase 4.5). Listed here as well as in Settings for the
   * reason this screen exists at all: five built, working routes were unreachable
   * from the navigation (`docs/26` §2.3), and a privacy control nobody can find is
   * a privacy control nobody uses.
   */
  { href: "/sharing", key: "sharing", Icon: Share2 },
];

/** Tools that produce an answer rather than store one. */
const TOOLS: readonly Tool[] = [
  { href: "/fertility", key: "fertility", Icon: Thermometer },
  { href: "/screeners", key: "screeners", Icon: HeartPulse },
  { href: "/calculators", key: "calculators", Icon: Calculator },
  { href: "/learn", key: "learn", Icon: Baby },
];

function ToolList({ items, heading }: { items: readonly Tool[]; heading: string }) {
  const t = useTranslations("tools");
  return (
    <section className="flex flex-col gap-2">
      <h2 className="text-sm font-semibold uppercase tracking-widest text-text-subtle">
        {heading}
      </h2>
      <ul className="flex flex-col gap-2">
        {items.map(({ href, key, Icon }) => (
          <li key={href}>
            <Card>
              <Link
                href={href}
                // min-h-14 rather than min-h-11: this is a list of destinations
                // scanned in a hurry, and the extra height is what keeps two
                // adjacent rows from being a mis-tap on a phone.
                className="flex min-h-14 items-center gap-3 px-4 py-3 hover:bg-surface-sunken"
              >
                <span className="flex size-9 shrink-0 items-center justify-center rounded-pill bg-surface-sunken">
                  <Icon className="size-4 text-text-muted" aria-hidden />
                </span>
                <span className="flex flex-col gap-0.5">
                  <span className="text-sm font-semibold text-text">{t(`${key}.label`)}</span>
                  <span className="text-2xs text-text-muted">{t(`${key}.note`)}</span>
                </span>
              </Link>
            </Card>
          </li>
        ))}
      </ul>
    </section>
  );
}

export function ToolsScreen() {
  const t = useTranslations("tools");
  return (
    <AppScreen>
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("intro")}</p>
      </div>

      <ToolList items={RECORD} heading={t("recordHeading")} />
      <ToolList items={TOOLS} heading={t("toolsHeading")} />
    </AppScreen>
  );
}
