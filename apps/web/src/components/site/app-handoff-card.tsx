import { useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import { Bloom } from "@/components/site/motifs";
import { buttonVariants } from "@/components/ui/button";
import { APP_PAGE, PLAY_STORE_URL } from "@/lib/site";
import { cn } from "@/lib/utils";

/**
 * "Track this in the app" (02_DESIGN_SPEC §2.12): the bridge from a calculator
 * or an article to the product. Sunken, not raised (the calculator card is the
 * page's one raised element); the button is the page's one accent. Neither link
 * carries a date or anything with health meaning.
 */
export function AppHandoffCard({ id = "handoff" }: { id?: string }) {
  const t = useTranslations("calculators.handoff");
  const playHref = PLAY_STORE_URL ?? APP_PAGE;
  return (
    <aside className="flex flex-col gap-4 rounded-lg bg-surface-sunken p-5" aria-labelledby={`${id}-title`}>
      <div className="flex items-start gap-3">
        <Bloom id={`${id}-bloom`} className="size-8 shrink-0" />
        <div className="flex flex-col gap-1">
          <h2 id={`${id}-title`} className="text-lg font-semibold text-text">
            {t("title")}
          </h2>
          <p className="text-sm text-text-muted">{t("body")}</p>
        </div>
      </div>
      <div className="flex flex-wrap items-center gap-3">
        <Link href={playHref} className={cn(buttonVariants({ variant: "accent", size: "lg" }))}>
          {PLAY_STORE_URL ? t("getOnPlay") : t("getTheApp")}
        </Link>
        <Link href={APP_PAGE} className="text-sm font-semibold text-text-link underline-offset-4 hover:underline">
          {t("whatItDoes")}
        </Link>
      </div>
    </aside>
  );
}
