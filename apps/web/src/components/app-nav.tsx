"use client";

import { BookOpen, CalendarDays, LayoutGrid, NotebookPen, Settings2, Sun } from "lucide-react";
import { useTranslations } from "next-intl";
import { Link, usePathname } from "@/i18n/navigation";
import { ThemeToggle } from "@/components/theme-toggle";
import { cn } from "@/lib/utils";

/**
 * The signed-in shell (P1.28.1, v3 P1.6).
 *
 * A slim brand bar at the top and a **bottom tab bar**. The tabs are the navigation;
 * the top bar is identity plus the two account actions. On a 390px screen the
 * reachable half is the bottom third, and mobile is where this product ships (ADR-048).
 *
 * v3 tabs (docs/30_REVAMP/03 §5 Phase 1): Today · Calendar · Log · Learn · Tools.
 * - **Learn joins the bar** (OD-12). The library is half of what Femio is, and it was
 *   reachable from the app only by leaving it.
 * - **Settings moves to a gear in the top bar.** It is an account action, not a place
 *   she visits daily, and five tabs is the ceiling before labels truncate. Every route
 *   the old bar reached is still one tap away (rule 2).
 * - Calendar stays a tab (RB-C5, OD-11); Tools stays a tab because five built routes
 *   were unreachable before it existed (`docs/archive/plans-2026-08/26` §2.3).
 */
const TABS = [
  // "Today", not "Dashboard": a tab label has ~78px here, and the screen is about her
  // day, not a panel of widgets.
  { href: "/dashboard", key: "today", Icon: Sun, match: ["/dashboard"] },
  { href: "/calendar", key: "calendar", Icon: CalendarDays, match: ["/calendar"] },
  { href: "/track", key: "log", Icon: NotebookPen, match: ["/track"] },
  { href: "/learn", key: "learn", Icon: BookOpen, match: ["/learn", "/conditions", "/search"] },
  {
    href: "/tools",
    key: "tools",
    Icon: LayoutGrid,
    match: [
      "/tools",
      "/summary",
      "/fertility",
      "/appointments",
      "/screeners",
      "/medications",
      "/patterns",
    ],
  },
] as const;

function isActive(pathname: string, match: readonly string[]): boolean {
  return match.some((m) => pathname === m || pathname.startsWith(`${m}/`));
}

/**
 * The tab bar alone. Rendered by the app shell, and by the public layout when a
 * signed-in woman reads an article, so that opening Learn never drops her out of the
 * app (`SignedInTabs`).
 */
export function BottomTabs() {
  const t = useTranslations("appNav");
  const pathname = usePathname();

  return (
    <nav
      aria-label={t("primary")}
      // `app-bottom-bar` is the shared hook globals.css uses to lift the crisis
      // launcher clear of anything fixed to the bottom of the screen.
      className="app-bottom-bar pb-safe fixed inset-x-0 bottom-0 z-sticky border-t border-border/70 bg-surface/90 backdrop-blur-md print:hidden"
    >
      <ul className="mx-auto flex max-w-2xl items-stretch justify-around px-1">
        {TABS.map(({ href, key, Icon, match }) => {
          const active = isActive(pathname, match);
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
                    strokeWidth={active ? 2.25 : 1.75}
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
  );
}

export function AppNav() {
  const t = useTranslations("appNav");
  const pathname = usePathname();
  const onSettings = isActive(pathname, ["/settings", "/sharing", "/shared-with-me", "/mfa"]);

  return (
    <>
      <header className="pt-safe sticky top-0 z-sticky border-b border-border/70 bg-bg/80 backdrop-blur-md print:hidden">
        <div className="mx-auto flex max-w-2xl items-center gap-1 px-4 py-2">
          {/* The wordmark is always English "femio", in every locale (product rule 6). */}
          <Link
            href="/dashboard"
            className="me-auto font-display text-2xl font-medium lowercase leading-none tracking-tight text-primary"
          >
            femio
          </Link>
          <ThemeToggle />
          <Link
            href="/settings"
            aria-label={t("settings")}
            aria-current={onSettings ? "page" : undefined}
            className={cn(
              "inline-flex size-11 items-center justify-center rounded-pill transition-colors duration-fast",
              onSettings
                ? "bg-primary-soft text-primary-soft-text"
                : "text-text-muted hover:bg-surface-sunken hover:text-text",
            )}
          >
            <Settings2 className="size-5" aria-hidden />
          </Link>
        </div>
      </header>
      <BottomTabs />
    </>
  );
}
