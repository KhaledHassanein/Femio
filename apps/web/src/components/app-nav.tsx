"use client";

import { LogOut } from "lucide-react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { Link, usePathname } from "@/i18n/navigation";
import { cn } from "@/lib/utils";

const LINKS = [
  { href: "/dashboard", key: "dashboard" },
  { href: "/track", key: "track" },
  { href: "/settings", key: "settings" },
] as const;

export function AppNav() {
  const t = useTranslations("appNav");
  const pathname = usePathname();
  const router = useRouter();

  const signOut = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/");
  };

  return (
    <header className="border-b border-border bg-surface">
      <nav className="mx-auto flex max-w-2xl items-center justify-between gap-4 px-6 py-3">
        <div className="flex items-center gap-1">
          {LINKS.map((l) => (
            <Link
              key={l.href}
              href={l.href}
              aria-current={pathname === l.href ? "page" : undefined}
              className={cn(
                "rounded-sm px-3 py-1.5 text-sm",
                pathname === l.href
                  ? "bg-primary-soft font-medium text-primary-soft-text"
                  : "text-text-muted hover:bg-surface-sunken",
              )}
            >
              {t(l.key)}
            </Link>
          ))}
        </div>
        <button
          type="button"
          onClick={signOut}
          className="inline-flex items-center gap-1 text-sm text-text-muted hover:text-text"
        >
          <LogOut className="size-4 rtl:-scale-x-100" aria-hidden />
          {t("signOut")}
        </button>
      </nav>
    </header>
  );
}
