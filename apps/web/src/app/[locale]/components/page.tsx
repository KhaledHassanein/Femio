import type { ReactNode } from "react";
import { AlertTriangle, CheckCircle2, Inbox, Info, ShieldAlert } from "lucide-react";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { Textarea } from "@/components/ui/textarea";
import { EmptyState } from "@/components/patterns/empty-state";
import { ErrorState } from "@/components/patterns/error-state";
import { LoadingState } from "@/components/patterns/loading-state";
import { ThemeToggle } from "@/components/theme-toggle";

type PageProps = { params: Promise<{ locale: string }> };

function Section({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section className="flex flex-col gap-4">
      <h2 className="text-sm font-semibold uppercase tracking-widest text-text-subtle">{title}</h2>
      {children}
    </section>
  );
}

// Literal class strings so Tailwind's JIT can see them (no dynamic concatenation).
const PHASES = [
  { key: "menstrual", swatch: "bg-phase-menstrual" },
  { key: "follicular", swatch: "bg-phase-follicular" },
  { key: "ovulatory", swatch: "bg-phase-ovulatory" },
  { key: "luteal", swatch: "bg-phase-luteal" },
] as const;

export default async function GalleryPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("gallery");

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-12 px-6 py-12">
      <header className="flex items-start justify-between gap-4">
        <div className="flex flex-col gap-1">
          <h1 className="font-display text-3xl text-text">{t("title")}</h1>
          <p className="text-sm text-text-muted">{t("subtitle")}</p>
        </div>
        <ThemeToggle />
      </header>

      <Section title={t("sections.buttons")}>
        <div className="flex flex-wrap items-center gap-3">
          <Button variant="primary">{t("buttons.primary")}</Button>
          <Button variant="accent">{t("buttons.accent")}</Button>
          <Button variant="outline">{t("buttons.outline")}</Button>
          <Button variant="ghost">{t("buttons.ghost")}</Button>
          <Button variant="primary" disabled>
            {t("buttons.primary")}
          </Button>
        </div>
      </Section>

      <Section title={t("sections.badges")}>
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant="neutral">Neutral</Badge>
          <Badge variant="primary">Primary</Badge>
          <Badge variant="accent">Accent</Badge>
          <Badge variant="success">Success</Badge>
          <Badge variant="warning">Warning</Badge>
          <Badge variant="danger">Danger</Badge>
        </div>
      </Section>

      <Section title={t("sections.forms")}>
        <Card>
          <CardContent className="flex flex-col gap-4 p-6">
            <div className="flex flex-col gap-2">
              <Label htmlFor="note">{t("form.label")}</Label>
              <Input id="note" placeholder={t("form.placeholder")} />
            </div>
            <Textarea placeholder={t("form.placeholder")} />
          </CardContent>
        </Card>
      </Section>

      <Section title={t("sections.feedback")}>
        <div className="flex flex-col gap-3">
          <Alert variant="info" icon={<Info className="size-5" />}>
            <AlertDescription>{t("feedback.info")}</AlertDescription>
          </Alert>
          <Alert variant="success" icon={<CheckCircle2 className="size-5" />}>
            <AlertDescription>{t("feedback.success")}</AlertDescription>
          </Alert>
          <Alert variant="warning" icon={<AlertTriangle className="size-5" />}>
            <AlertDescription>{t("feedback.warning")}</AlertDescription>
          </Alert>
          <Alert variant="danger" icon={<ShieldAlert className="size-5" />}>
            <AlertTitle>{t("feedback.redFlagTitle")}</AlertTitle>
            <AlertDescription>{t("feedback.redFlagBody")}</AlertDescription>
          </Alert>
        </div>
      </Section>

      <Section title={t("sections.states")}>
        <div className="grid gap-4 sm:grid-cols-3">
          <EmptyState
            icon={<Inbox className="size-8" />}
            title={t("empty.title")}
            description={t("empty.body")}
          />
          <ErrorState
            icon={<AlertTriangle className="size-8" />}
            title={t("error.title")}
            description={t("error.body")}
            action={
              <Button variant="outline" size="sm">
                {t("error.retry")}
              </Button>
            }
          />
          <Card>
            <CardContent className="p-6">
              <LoadingState label={t("loading")} />
            </CardContent>
          </Card>
        </div>
      </Section>

      <Section title={t("sections.phases")}>
        <div className="flex flex-wrap gap-4">
          {PHASES.map((phase) => (
            <div key={phase.key} className="flex items-center gap-2">
              <span className={`size-6 rounded-pill ${phase.swatch}`} aria-hidden />
              <span className="text-sm text-text">{t(`phases.${phase.key}`)}</span>
            </div>
          ))}
        </div>
        <Separator />
      </Section>
    </main>
  );
}
