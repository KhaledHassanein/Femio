"use client";

import { useTranslations } from "next-intl";
import { Printer } from "lucide-react";
import { Button } from "@/components/ui/button";

// "Print / Save as PDF" — uses the browser's native print-to-PDF. No PDF library
// and no server rendering, so health data never leaves the owner's device/session.
export function PrintButton() {
  const t = useTranslations("visitSummary");
  return (
    <Button variant="primary" onClick={() => window.print()} className="print:hidden">
      <Printer className="size-4" aria-hidden />
      {t("print")}
    </Button>
  );
}
