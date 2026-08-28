"use client";

import { CalendarDays, CalendarHeart, House, LayoutGrid, Settings2 } from "lucide-react";
import { useTranslations } from "next-intl";
import { Link, usePathname } from "@/i18n/navigation";
import { ThemeToggle } from "@/components/theme-toggle";
import { cn } from "@/lib/utils";

/**
 * The signed-in shell (P1.28.1).
 *
 * Two pieces: a slim brand bar at the top and a **bottom tab bar** — the tabs are
 * the navigation, the top bar is only identity. Three text links in a header is
 * website chrome; on a 390px screen the reachable half is the bottom third, and
 * mobile is where this product ships (ADR-048).
 *
 * Sign-out deliberately left the nav for Settings. It sat one mis-tap from "Track"
 * and it is not a place you navigate to — it is an account action.
 */
const TABS = [
  // "Home", not "Dashboard": a tab label has ~110px on a 390px screen, and
  // "Tableau de bord" does not fit in it.
  { href: "/dashboard", key: "home", Icon: House },
  { href: "/track", key: "track", Icon: CalendarHeart },
  /**
   * Calendar, promoted from an icon to a tab (RB-C5). `docs/29_REBUILD/06` §2:
   * it is the surface she looks at most, and it was reachable only from inside
   * Track. Five tabs is the ceiling on a 390px screen — anything more and the
   * labels truncate before the icons do.
   */
  { href: "/calendar", key: "calendar", Icon: CalendarDays },
  /**
   * Tools (R3.2.1). Five built, working routes — the visit summary, fertility
   * charting, appointments, screeners and medications — were unreachable from the
   * navigation entirely (`docs/26` §2.3), so the app was bigger than its own nav
   * admitted and a third of that nav was Settings.
   */
  { href: "/tools", key: "tools", Icon: LayoutGrid },
  { href: "/settings", key: "settings", Icon: Settings2 },
] as const;

export function AppNav() {
  const t = useTranslations("appNav");
  const pathname = usePathname();

  return (
    <>
      <header className="pt-safe sticky top-0 z-sticky border-b border-border bg-surface/80 backdrop-blur print:hidden">
        <div className="mx-auto flex max-w-2xl items-center justify-between gap-4 px-6 py-3">
          {/* The wordmark is always English "femio", in every locale (product rule 6). */}
          <Link
            href="/dashboard"
            className="font-display text-lg lowercase tracking-tight text-primary"
          >
            femio
          </Link>
          <ThemeToggle />
        </div>
      </header>

      <nav
        aria-label={t("primary")}
        // `app-bottom-bar` is the shared hook globals.css uses to lift the crisis
        // launcher clear of anything fixed to the bottom of the screen.
        className="app-bottom-bar pb-safe fixed inset-x-0 bottom-0 z-sticky border-t border-border bg-surface/95 backdrop-blur print:hidden"
      >
        <ul className="mx-auto flex max-w-2xl items-stretch justify-around px-2">
          {TABS.map(({ href, key, Icon }) => {
            const active = pathname === href;
            return (
              <li key={href} className="flex-1">
                <Link
                  href={href}
                  aria-current={active ? "page" : undefined}
                  className={cn(
                    // 56px of height plus the icon padding clears the 44px touch
                    // target minimum on every tab, label included.
                    "flex min-h-14 flex-col items-center justify-center gap-1 rounded-sm py-2 text-2xs font-medium transition-colors duration-fast",
                    active ? "text-primary" : "text-text-subtle hover:text-text",
                  )}
                >
                  <span
                    className={cn(
                      "flex items-center justify-center rounded-pill px-4 py-1 transition-colors duration-fast",
                      active ? "bg-primary-soft" : "bg-transparent",
                    )}
                  >
                    <Icon
                      className={cn("size-5", active && "text-primary-soft-text")}
                      aria-hidden
                    />
                  </span>
                  {t(key)}
                </Link>
              </li>
            );
          })}
        </ul>
      </nav>
    </>
  );
}
