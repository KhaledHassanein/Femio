import { getTranslations } from "next-intl/server";
import { ClipboardList } from "lucide-react";
import { PCOS_CHECKLIST_PATH } from "@/lib/checklists/pcos";
import { Link } from "@/i18n/navigation";

/** The PCOS hub's card leading to the printable visit checklist (R13.6). */
export async function VisitChecklistLink() {
  const t = await getTranslations("pcosChecklist");
  return (
    <Link
      href={PCOS_CHECKLIST_PATH}
      className="flex items-start gap-4 rounded-lg border border-border bg-surface p-5 transition-shadow hover:shadow-md print:hidden"
    >
      <span className="flex size-12 shrink-0 items-center justify-center rounded-pill bg-primary-soft text-primary-soft-text">
        <ClipboardList className="size-6" aria-hidden />
      </span>
      <span className="flex flex-col gap-1">
        <span className="font-display text-lg text-text">{t("hubTitle")}</span>
        <span className="text-sm text-text-muted">{t("hubBody")}</span>
        <span className="text-sm font-semibold text-text-link">{t("hubLink")}</span>
      </span>
    </Link>
  );
}
