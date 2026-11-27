"use client";

import { Printer } from "lucide-react";
import { Button } from "@/components/ui/button";

/**
 * Opens the browser's own print dialog. The one script the checklist page needs: it
 * reads nothing she ticked. The label arrives as a prop, so no message namespace is
 * shipped to the browser for it.
 */
export function PrintButton({ label }: { label: string }) {
  return (
    <Button type="button" size="lg" className="w-fit print:hidden" onClick={() => window.print()}>
      <Printer className="size-5" aria-hidden />
      {label}
    </Button>
  );
}
