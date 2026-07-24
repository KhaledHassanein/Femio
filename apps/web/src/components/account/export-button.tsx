"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { buildExport } from "@/lib/account/export-data";
import { Button } from "@/components/ui/button";

export function ExportButton() {
  const t = useTranslations("settings");
  const [busy, setBusy] = useState(false);

  const download = async () => {
    setBusy(true);
    try {
      const data = await buildExport();
      const blob = new Blob([JSON.stringify(data, null, 2)], { type: "application/json" });
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = `femio-export-${new Date().toISOString().slice(0, 10)}.json`;
      a.click();
      URL.revokeObjectURL(url);
    } finally {
      setBusy(false);
    }
  };

  return (
    <Button variant="outline" onClick={download} disabled={busy} className="self-start">
      {busy ? t("exporting") : t("export.button")}
    </Button>
  );
}
