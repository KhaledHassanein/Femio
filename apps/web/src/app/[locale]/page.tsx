import { getTranslations, setRequestLocale } from "next-intl/server";
import { Button } from "@/components/ui/button";

type PageProps = {
  params: Promise<{ locale: string }>;
};

export default async function HomePage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("home");

  return (
    <main className="mx-auto flex min-h-dvh max-w-3xl flex-col justify-center gap-6 px-6 py-16">
      <p className="text-sm font-semibold uppercase tracking-widest text-primary">
        {t("eyebrow")}
      </p>
      <h1 className="font-display text-3xl text-text">{t("title")}</h1>
      <p className="max-w-prose text-md text-text-muted">{t("body")}</p>
      <div>
        <Button variant="accent" size="lg">
          {t("cta")}
        </Button>
      </div>
      <div className="flex flex-wrap gap-3">
        <span className="rounded-pill bg-primary-soft px-4 py-2 text-sm text-primary-soft-text">
          {t("chips.primary")}
        </span>
        <span className="rounded-pill bg-accent-soft px-4 py-2 text-sm text-accent">
          {t("chips.accent")}
        </span>
        <span className="rounded-pill bg-success-soft px-4 py-2 text-sm text-success-text">
          {t("chips.fertile")}
        </span>
        <span className="rounded-pill bg-warning-soft px-4 py-2 text-sm text-warning-text">
          {t("chips.uncertainty")}
        </span>
      </div>
    </main>
  );
}
