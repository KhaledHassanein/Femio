"use client";

import { useTranslations } from "next-intl";

/**
 * The heading and the boundary sentence, said once at the top of the screeners
 * page rather than repeated on each card (P2.7).
 *
 * Client-side because the page's other two children are, and a server component
 * here would be the only server read on the tracker path for one `<h1>`.
 */
export function ScreenersIntro() {
  const t = useTranslations("moodScreeners");
  return (
    <div className="flex flex-col gap-2">
      <h1 className="font-display text-lg text-text">{t("title")}</h1>
      <p className="text-sm text-text-muted">{t("pageIntro")}</p>
    </div>
  );
}
