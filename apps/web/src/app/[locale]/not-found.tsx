"use client";

import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { Button } from "@/components/ui/button";

/**
 * Localized 404 (P1.2.2 — and the fix for a production-only 500).
 *
 * Without this boundary, `notFound()` thrown from a content route fell through
 * to Next's built-in not-found, which renders inside `[locale]/layout.tsx`
 * *without* a request locale. next-intl then reached for `headers()` to work one
 * out, which is a dynamic API — illegal during the static/ISR render those
 * routes use — so every unknown slug under `/learn`, `/conditions` and
 * `/authors` returned **500 instead of 404** in production (dev renders
 * dynamically, so it looked fine locally for weeks).
 *
 * A client component is the fix, not a workaround: it reads the messages the
 * layout already put in `NextIntlClientProvider`, so rendering this page needs
 * no server-side locale resolution and therefore no dynamic API at all.
 */
export default function NotFound() {
  const t = useTranslations("notFound");

  return (
    <main className="mx-auto flex w-full max-w-xl flex-1 flex-col items-start gap-4 px-6 py-16">
      <p className="text-sm text-text-subtle">{t("code")}</p>
      <h1 className="font-display text-3xl text-text">{t("title")}</h1>
      <p className="text-md text-text-muted">{t("body")}</p>
      <div className="mt-2 flex flex-wrap gap-3">
        <Button asChild>
          <Link href="/">{t("home")}</Link>
        </Button>
        <Button asChild variant="outline">
          <Link href="/learn">{t("learn")}</Link>
        </Button>
      </div>
    </main>
  );
}
