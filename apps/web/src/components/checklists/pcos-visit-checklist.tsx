import type { ReactNode } from "react";
import { getTranslations } from "next-intl/server";
import { LifeBuoy, TriangleAlert } from "lucide-react";
import { PrintButton } from "@/components/checklists/print-button";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { PCOS_EXPERIENCES, PCOS_QUESTIONS } from "@/lib/checklists/pcos";
import { Link } from "@/i18n/navigation";

const HEADING = "font-display text-2xl text-text print:text-xl";
const SUBHEADING = "text-md font-semibold text-text";
// A group stays on one sheet, so a heading never prints without its lines.
const GROUP = "flex break-inside-avoid flex-col gap-1";

/**
 * The printable part of the PCOS visit checklist (R13.6): things she may have noticed,
 * as native checkboxes, then questions to ask, then the two "seek care now" notes.
 *
 * The checkboxes are uncontrolled on purpose. No script reads them, nothing is
 * counted, stored or sent, and the page draws no result (D-04): a tick exists only on
 * her screen and her printout. Server component; `PrintButton` is the one client part.
 */
export async function PcosVisitChecklist() {
  const t = await getTranslations("pcosChecklist");
  const help = (chunks: ReactNode) => (
    <Link href="/help-now" className="font-semibold underline">
      {chunks}
    </Link>
  );

  return (
    <>
      <PrintButton label={t("print")} />

      <section aria-labelledby="noticed-title" className="flex flex-col gap-4">
        <div className="flex flex-col gap-1">
          <h2 id="noticed-title" className={HEADING}>
            {t("experiencesTitle")}
          </h2>
          <p className="text-sm text-text-muted print:hidden">
            {t("experiencesHint")} {t("privacy")}
          </p>
        </div>
        {PCOS_EXPERIENCES.map((group) => (
          <fieldset key={group.key} className="break-inside-avoid">
            <legend className={`${SUBHEADING} mb-1`}>{t(`experienceGroups.${group.key}`)}</legend>
            {group.lines.map(({ key }) => (
              <label key={key} className="flex min-h-11 cursor-pointer items-start gap-3 py-2 print:min-h-0 print:py-1">
                <input type="checkbox" autoComplete="off" className="mt-0.5 size-5 shrink-0 accent-primary print:size-4" />
                <span className="text-base text-text print:text-sm">{t(`experiences.${key}`)}</span>
              </label>
            ))}
          </fieldset>
        ))}
        <Alert variant="warning" icon={<TriangleAlert className="size-5" />} className="break-inside-avoid">
          <AlertDescription>{t("rapid")}</AlertDescription>
        </Alert>
      </section>

      <section aria-labelledby="questions-title" className="flex flex-col gap-4">
        <h2 id="questions-title" className={HEADING}>
          {t("questionsTitle")}
        </h2>
        {PCOS_QUESTIONS.map((group) => (
          <div key={group.key} className={GROUP}>
            <h3 className={SUBHEADING}>{t(`questionGroups.${group.key}`)}</h3>
            <ul className="flex list-disc flex-col gap-2 ps-5 text-base text-text print:gap-1 print:text-sm">
              {group.lines.map(({ key }) => (
                <li key={key}>{t(`questions.${key}`)}</li>
              ))}
            </ul>
          </div>
        ))}
      </section>

      <Alert variant="danger" icon={<LifeBuoy className="size-5" />} className="break-inside-avoid">
        <AlertTitle>{t("urgentTitle")}</AlertTitle>
        <AlertDescription>{t("urgentBody")}</AlertDescription>
        <AlertDescription>{t.rich("urgentMood", { help })}</AlertDescription>
      </Alert>
    </>
  );
}
