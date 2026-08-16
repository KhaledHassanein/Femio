import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { AuthGate } from "@/components/auth/auth-gate";
import { MoodScreener } from "@/components/screeners/mood-screener";
import { AppScreen } from "@/components/patterns/app-screen";
import { ScreenersIntro } from "@/components/screeners/screeners-intro";

type PageProps = { params: Promise<{ locale: string }> };

// Client-rendered screeners so the tracker can run without a server (P4.0, ADR-048).
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "moodScreeners" });
  return { title: t("title"), robots: { index: false, follow: false } };
}

/**
 * The screeners a woman can reach in any mode (P2.7).
 *
 * PHQ-9 and GAD-7 are general instruments, not stage-specific ones — the EPDS lives
 * on the postpartum screen because it is perinatal, and these do not belong behind a
 * life stage for the same reason appointments and charting do not.
 */
export default async function ScreenersPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return (
    <AuthGate>
      <AppScreen>
        <ScreenersIntro />
        <MoodScreener tool="PHQ9" />
        <MoodScreener tool="GAD7" />
      </AppScreen>
    </AuthGate>
  );
}
