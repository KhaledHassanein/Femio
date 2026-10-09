import { isUnpublishedSection } from "@/lib/content/unpublished-sections";
import { getTranslations, setRequestLocale } from "next-intl/server";
import {
  ArrowRight,
  Baby,
  CalendarHeart,
  Flower2,
  Lock,
  MoonStar,
  Save,
  ShieldCheck,
  TestTube,
  Timer,
  UserRoundX,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { JsonLd } from "@/components/seo/json-ld";
import { organizationJsonLd, websiteJsonLd } from "@/lib/seo/jsonld";
import { Link } from "@/i18n/navigation";
import { APP_PAGE } from "@/lib/web-app";
import { PageView } from "@/components/analytics/page-view";
import { PhoneMock } from "@/components/site/phone-mock";
import { Bloom, Moon, Petal, Spark } from "@/components/site/motifs";

type PageProps = { params: Promise<{ locale: string }> };

/**
 * The public homepage, rebuilt as the app's front door (P2.3, D8, ADR-070).
 *
 * The website's job changed: it is articles, calculators and the way to the Android
 * app. So the page follows what women come for, in the order competitors have taught
 * them (Flo, Clue: product in the hero, goals, tools), then says what only Femio says:
 *
 *   hero (the app) → goals → free calculators → honesty shown → every stage →
 *   private by design → trust → library → close
 *
 * - **Goals are the first question**, as in every tracker's onboarding (spec §2):
 *   period, pregnant-soon, pregnant, menopause. Each leads to the tool for it.
 * - **Feminine, from our own mark**: the Bloom petal, the moon, a spark (`motifs.tsx`),
 *   in Dusk Bloom art tokens. Decorative only.
 * - **Privacy is structural, so it is a section, not a badge**: no account, records on
 *   the phone (D7). Nothing on this page claims an account or EU storage any more.
 *
 * Server-rendered: the SEO landing page, not on the tracker path.
 */

const STAGES = ["teen", "cycle", "ttc", "pregnancy", "postpartum", "menopause"] as const;
/**
 * `sources` leads: every guide cites them, which is true of all 100. `reviewed` was
 * "Every guide is reviewed by a clinician" until 2026-10-08, when the competitor
 * benchmark (docs/30_REVAMP/delegated/) counted the snapshot: 25 of 100 guides carry
 * a named reviewer. The claim now says only what is true of each page — a reviewed
 * guide names its reviewer — and goes back to "every" when every guide has one.
 */
const TRUST = ["sources", "reviewed", "ads", "languages"] as const;
const SECTIONS = [
  { key: "learn", href: "/learn" },
  { key: "conditions", href: "/conditions" },
  { key: "calculators", href: "/calculators" },
  { key: "faq", href: "/faq" },
  { key: "glossary", href: "/glossary" },
] as const;

/** Section frame. `sunken` alternates the background so seven sections still read. */
function Section({ children, sunken = false }: { children: React.ReactNode; sunken?: boolean }) {
  return (
    <section className={sunken ? "bg-surface-sunken" : undefined}>
      <div className="reveal mx-auto flex w-full max-w-3xl flex-col gap-4 px-6 py-12">
        {children}
      </div>
    </section>
  );
}

function Eyebrow({ children }: { children: React.ReactNode }) {
  return (
    <p className="text-2xs font-semibold uppercase tracking-wider text-primary rtl:normal-case rtl:tracking-normal">
      {children}
    </p>
  );
}

const GOALS = [
  {
    key: "period",
    href: "/calculators/period",
    Icon: CalendarHeart,
    tone: "bg-log-period-alt text-log-period",
  },
  {
    key: "ttc",
    href: "/calculators/fertile-window",
    Icon: Flower2,
    tone: "bg-success-soft text-success-text",
  },
  {
    key: "pregnant",
    href: "/calculators/due-date",
    Icon: Baby,
    tone: "bg-accent-soft text-accent-soft-text",
  },
  {
    key: "menopause",
    // The menopause row of the library, not its top (audit F10).
    href: "/learn#menopause",
    Icon: MoonStar,
    tone: "bg-primary-soft text-primary-soft-text",
  },
] as const;

const TOOLS = [
  { slug: "period", key: "period", Icon: CalendarHeart },
  { slug: "fertile-window", key: "ovulation", Icon: Flower2 },
  { slug: "pregnancy-test", key: "pregnancyTest", Icon: TestTube },
  { slug: "due-date", key: "dueDate", Icon: Baby },
  { slug: "gestational-age", key: "gestationalAge", Icon: Timer },
] as const;

const PRIVACY = [
  { key: "account", Icon: UserRoundX },
  { key: "never", Icon: Lock },
  { key: "backup", Icon: Save },
] as const;

export default async function HomePage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("home");
  const tc = await getTranslations("calculators");
  const tApp = await getTranslations("getApp");

  return (
    <main className="flex w-full flex-1 flex-col">
      <PageView area="home" />
      <JsonLd data={websiteJsonLd(locale)} />
      <JsonLd data={organizationJsonLd()} />

      {/* ── Hero: the app ───────────────────────────────────────────────────── */}
      <section className="aurora relative overflow-hidden text-text-on-brand">
        {/* Floating motifs. Decorative; they sit behind the copy and never carry text. */}
        <Bloom
          id="hero-bloom"
          className="pointer-events-none absolute -end-16 -top-16 size-64 opacity-25 motion-safe:animate-[spin_90s_linear_infinite]"
        />
        <Petal className="pointer-events-none absolute start-[8%] top-24 h-10 rotate-[-25deg] text-white/20" />
        <Moon className="pointer-events-none absolute end-[12%] bottom-10 size-8 text-white/25" />
        <Spark className="pointer-events-none absolute start-[46%] top-10 size-4 text-white/40" />
        <Spark className="pointer-events-none absolute start-[14%] bottom-24 size-3 text-white/30" />

        <div className="relative mx-auto flex w-full max-w-5xl flex-col items-center gap-10 px-6 pb-16 pt-12 md:flex-row">
          <div className="flex flex-1 flex-col gap-4">
            <p className="text-2xs font-semibold uppercase tracking-widest opacity-85 rtl:tracking-normal">
              {t("hero.eyebrow")}
            </p>
            <h1 className="font-display text-2xl leading-tight sm:text-4xl rtl:font-bold rtl:leading-relaxed">
              {t("hero.title")}
            </h1>
            <p className="text-sm leading-relaxed opacity-95">{t("hero.body")}</p>
            <div className="mt-2 flex flex-col gap-3 sm:flex-row">
              <Button asChild variant="accent" size="lg" className="w-full sm:w-auto">
                <Link href={APP_PAGE}>{t("hero.cta")}</Link>
              </Button>
              <Button
                asChild
                variant="outline"
                size="lg"
                className="w-full border-white/55 bg-transparent text-text-on-brand hover:bg-white/10 sm:w-auto"
              >
                <Link href="/calculators/period">{t("hero.ctaSecondary")}</Link>
              </Button>
            </div>
            <p className="text-2xs opacity-85">
              {tApp("android")} · {tApp("androidStatus")} &nbsp;·&nbsp; {tApp("ios")} ·{" "}
              {tApp("iosStatus")}
            </p>
          </div>
          <PhoneMock
            strings={{
              day: tApp("mock.day"),
              title: tApp("mock.title"),
              range: tApp("mock.range"),
              note: tApp("mock.note"),
              period: tApp("mock.period"),
            }}
          />
        </div>
      </section>

      {/* ── Goals: the first question every tracker asks ────────────────────── */}
      <section className="mx-auto w-full max-w-5xl px-6 pt-12">
        <h2 className="font-display text-xl text-text rtl:font-bold">{t("goals.heading")}</h2>
        <ul className="mt-5 grid grid-cols-2 gap-3 lg:grid-cols-4">
          {GOALS.map(({ key, href, Icon, tone }) => (
            <li key={key}>
              <Link
                href={href}
                className={`group relative flex h-full flex-col gap-3 overflow-hidden rounded-lg p-4 transition-transform motion-safe:hover:-translate-y-0.5 ${tone}`}
              >
                <Petal className="pointer-events-none absolute -bottom-6 -end-3 h-24 rotate-[35deg] opacity-[0.18]" />
                <span className="flex size-11 items-center justify-center rounded-pill bg-surface/70">
                  <Icon className="size-6" aria-hidden />
                </span>
                <span className="text-sm font-semibold leading-snug">
                  {t(`goals.${key}.title`)}
                </span>
                <span className="text-2xs leading-relaxed">{t(`goals.${key}.body`)}</span>
              </Link>
            </li>
          ))}
        </ul>
      </section>

      {/* ── Free calculators: how women find a period app ───────────────────── */}
      <Section>
        <div className="flex items-end justify-between gap-3">
          <div>
            <h2 className="font-display text-lg text-text rtl:font-bold">{t("tools.heading")}</h2>
            <p className="text-2xs text-text-muted">{t("tools.sub")}</p>
          </div>
          <Link href="/calculators" className="shrink-0 text-xs font-semibold text-text-link">
            {t("tools.more")}
          </Link>
        </div>
        <ul className="flex flex-col gap-2">
          {TOOLS.map(({ slug, key, Icon }) => (
            <li key={slug}>
              <Link
                href={`/calculators/${slug}`}
                className="group flex items-center gap-3 rounded-md border border-border bg-surface p-3 transition-colors hover:bg-surface-sunken"
              >
                <span className="flex size-10 shrink-0 items-center justify-center rounded-pill bg-primary-soft text-primary-soft-text">
                  <Icon className="size-5" aria-hidden />
                </span>
                <span className="flex-1 text-sm font-semibold text-text">
                  {tc(`list.${key}.name`)}
                </span>
                <ArrowRight
                  className="size-4 text-text-subtle transition-transform group-hover:translate-x-0.5 rtl:-scale-x-100"
                  aria-hidden
                />
              </Link>
            </li>
          ))}
        </ul>
      </Section>

      {/* ── The life-stage rail — the claim no competitor can answer ────────── */}
      <Section>
        <Eyebrow>{t("rail.eyebrow")}</Eyebrow>
        <h2 className="font-display text-lg text-text rtl:font-bold">{t("rail.heading")}</h2>
        <p className="text-xs leading-relaxed text-text-muted">{t("rail.sub")}</p>

        <ul className="relative mt-2 flex flex-col ps-4">
          {/* The phase-colour spine is decorative reinforcement — every stage is
              named in text, so colour is never the only channel. */}
          <span
            className="absolute inset-y-2 start-[3px] w-0.5 rounded-pill bg-[linear-gradient(180deg,var(--phase-menstrual),var(--phase-follicular),var(--phase-ovulatory),var(--phase-luteal))] opacity-60"
            aria-hidden
          />
          {STAGES.map((s) => (
            <li key={s} className="relative py-2">
              <span
                className="absolute -start-4 top-3.5 size-2.5 rounded-round border-2 border-primary bg-surface"
                aria-hidden
              />
              <span className="block text-sm font-semibold text-text">
                {t(`rail.stages.${s}.name`)}
              </span>
              <span className="block text-2xs text-text-subtle">{t(`rail.stages.${s}.note`)}</span>
            </li>
          ))}
        </ul>

        <p className="mt-2 rounded-md bg-primary-soft px-4 py-3 text-2xs leading-relaxed text-primary-soft-text">
          {t("rail.foot")}
        </p>
      </Section>

      {/* ── Honesty, shown rather than claimed ──────────────────────────────── */}
      <Section sunken>
        <Eyebrow>{t("proof.eyebrow")}</Eyebrow>
        <h2 className="font-display text-lg text-text rtl:font-bold">{t("proof.heading")}</h2>

        <div className="mt-2 flex flex-col gap-4">
          <article className="rounded-md bg-surface p-5 shadow-sm">
            <h3 className="text-sm font-semibold text-text">{t("proof.band.title")}</h3>
            <p className="mt-2 text-2xs leading-relaxed text-text-muted">{t("proof.band.body")}</p>
            <span className="relative mt-4 block h-2 rounded-pill bg-surface-sunken" aria-hidden>
              <span className="absolute inset-y-0 start-[34%] w-[38%] rounded-pill bg-[linear-gradient(90deg,transparent,var(--prediction-band)_35%,var(--prediction-band)_65%,transparent)]" />
              <span className="absolute -inset-y-1 start-[52%] w-[3px] -ms-[1.5px] rounded-pill bg-text" />
            </span>
            <span className="mt-2 flex justify-between text-2xs text-text-subtle">
              <span>{t("proof.band.legendStart")}</span>
              <span>{t("proof.band.legendEnd")}</span>
            </span>
          </article>

          <article className="rounded-md bg-surface p-5 shadow-sm">
            <h3 className="text-sm font-semibold text-text">{t("proof.late.title")}</h3>
            <p className="mt-2 text-2xs leading-relaxed text-text-muted">{t("proof.late.body")}</p>
            <p className="mt-4 rounded-md bg-warning-soft px-4 py-3 text-2xs leading-relaxed text-warning-text">
              {t("proof.late.notice")}
            </p>
          </article>

          <article className="rounded-md bg-surface p-5 shadow-sm">
            <h3 className="text-sm font-semibold text-text">{t("proof.pattern.title")}</h3>
            <p className="mt-2 text-2xs leading-relaxed text-text-muted">
              {t("proof.pattern.body")}
            </p>
            {/* The strip: size AND opacity carry the value, never colour alone. */}
            <span className="mt-4 flex h-9 items-end gap-[3px]" aria-hidden>
              {STRIP.map((h, i) => (
                <span
                  key={i}
                  className="block flex-1 rounded-xs bg-phase-menstrual"
                  style={{ height: `${h}%`, opacity: 0.2 + (h / 100) * 0.8 }}
                />
              ))}
            </span>
          </article>
        </div>
      </Section>

      {/* ── Private by design (D7): a structure, so a section, not a badge ───── */}
      <section className="relative overflow-hidden bg-[var(--aurora-ground)] text-text-on-brand">
        <Bloom
          id="privacy-bloom"
          className="pointer-events-none absolute -start-20 -bottom-20 size-72 opacity-15"
        />
        <div className="reveal relative mx-auto flex w-full max-w-3xl flex-col gap-4 px-6 py-14">
          <p className="flex items-center gap-2 text-2xs font-semibold uppercase tracking-wider opacity-85 rtl:tracking-normal">
            <ShieldCheck className="size-4" aria-hidden />
            {t("privacy.eyebrow")}
          </p>
          <h2 className="font-display text-xl rtl:font-bold">{t("privacy.heading")}</h2>
          <p className="text-sm leading-relaxed opacity-90">{t("privacy.body")}</p>
          <ul className="mt-2 grid gap-3 sm:grid-cols-3">
            {PRIVACY.map(({ key, Icon }) => (
              <li
                key={key}
                className="flex flex-col gap-2 rounded-lg bg-white/10 p-4 ring-1 ring-white/15"
              >
                <Icon className="size-5" aria-hidden />
                <span className="text-sm font-semibold">{t(`privacy.points.${key}.title`)}</span>
                <span className="text-2xs leading-relaxed opacity-85">
                  {t(`privacy.points.${key}.body`)}
                </span>
              </li>
            ))}
          </ul>
        </div>
      </section>

      {/* ── Trust: verifiable facts, not badges ─────────────────────────────── */}
      <Section>
        <Eyebrow>{t("trust.eyebrow")}</Eyebrow>
        <h2 className="font-display text-lg text-text rtl:font-bold">{t("trust.heading")}</h2>
        <ul className="mt-2 flex flex-col">
          {TRUST.map((k) => (
            <li
              key={k}
              className="flex items-start gap-3 border-b border-border py-3 text-xs leading-relaxed text-text last:border-b-0"
            >
              <span
                className="mt-0.5 grid size-[18px] flex-none place-items-center rounded-round bg-success-soft text-[11px] font-bold text-success-text"
                aria-hidden
              >
                ✓
              </span>
              <span>
                <span className="font-semibold">{t(`trust.items.${k}.claim`)}</span>{" "}
                <span className="text-text-muted">{t(`trust.items.${k}.detail`)}</span>
              </span>
            </li>
          ))}
        </ul>
      </Section>

      {/* ── The library, demoted but complete (product rule 2) ──────────────── */}
      <Section sunken>
        <Eyebrow>{t("library.eyebrow")}</Eyebrow>
        <h2 className="font-display text-lg text-text rtl:font-bold">{t("library.heading")}</h2>
        <div className="mt-2 flex flex-col gap-3">
          {SECTIONS.filter((s) => !isUnpublishedSection(s.href)).map((s) => (
            <Link
              key={s.key}
              href={s.href}
              className="group flex items-center justify-between gap-3 rounded-md bg-surface p-4 shadow-xs transition-colors duration-fast hover:bg-surface-sunken"
            >
              <span>
                <span className="block text-xs font-semibold text-text">
                  {t(`sections.${s.key}.name`)}
                </span>
                <span className="mt-0.5 block text-2xs text-text-subtle">
                  {t(`sections.${s.key}.desc`)}
                </span>
              </span>
              <ArrowRight
                className="size-4 flex-none text-text-subtle transition-transform group-hover:translate-x-0.5 rtl:-scale-x-100"
                aria-hidden
              />
            </Link>
          ))}
        </div>
      </Section>

      {/* ── Close ───────────────────────────────────────────────────────────── */}
      <Section>
        <div className="flex flex-col items-center gap-5 text-center">
          <Bloom id="close-bloom" className="size-14" />
          <h2 className="font-display text-lg text-text rtl:font-bold">{t("close.heading")}</h2>
          <Button asChild variant="accent" size="lg" className="w-full sm:w-auto">
            <Link href={APP_PAGE}>{t("hero.cta")}</Link>
          </Button>
          <p className="text-2xs leading-relaxed text-text-subtle">{t("disclaimer")}</p>
        </div>
      </Section>
    </main>
  );
}

/** Thirty days of one woman's flow. Shape only — no claim attaches to the values. */
const STRIP = [
  20, 12, 12, 70, 100, 80, 45, 25, 12, 12, 18, 12, 30, 12, 12, 22, 12, 12, 40, 12, 12, 12, 28, 12,
  12, 65, 95, 72, 38, 18,
] as const;
