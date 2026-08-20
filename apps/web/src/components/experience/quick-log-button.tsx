"use client";

import { useTranslations } from "next-intl";

import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";

/**
 * The primary log action, owned by the registry rather than by the screens.
 *
 * It was a slot on `ModuleContext` until now, and every one of the six experience
 * components filled it with the same three lines. That is how R1.9l happened: the
 * slot's type is `ReactNode`, so `quickLog: null` type-checks perfectly, three
 * components passed it, `dashboard-screen` suppressed its own button because the
 * served document *did* carry the module — and three live dashboards lost the CTA
 * while the engine looked correct. The fix at the time pasted the block into the
 * three, which left six copies and a source-scanning test standing guard over them.
 *
 * There is nothing for a caller to decide here: no persona ever varied the label,
 * the variant or the destination. So the module owns its own component, exactly as
 * the clinical strips do (`strip.labs` and its four siblings), and the failure the
 * test was watching for is now unrepresentable — there is no slot left to null out.
 */
export function QuickLogButton() {
  const t = useTranslations("dashboard");
  return (
    <Button asChild variant="accent" className="w-full">
      <Link href="/track">{t("logCta")}</Link>
    </Button>
  );
}
