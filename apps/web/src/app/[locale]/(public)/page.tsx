import { getTranslations, setRequestLocale } from "next-intl/server";
import { ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { JsonLd } from "@/components/seo/json-ld";
import { organizationJsonLd, websiteJsonLd } from "@/lib/seo/jsonld";
import { Link } from "@/i18n/navigation";
import { APP_PAGE, webAppEnabled } from "@/lib/web-app";
import { PageView } from "@/components/analytics/page-view";

type PageProps = { params: Promise<{ locale: string }> };

/**
 * The public homepage (R1.3, `assets/mockups/R1.3_homepage_reference.html`).
 *
 * What this replaced: a hero sentence over five visually identical link cards — a
 * sitemap with a headline. It showed no product, gave no reason to trust, and said
 * nothing a competitor could not say.
 *
 * The order of the page is the argument, and each section earns its place from the
 * competitor teardown in `docs/03` §H:
 *
 *   hero → product → life-stage rail → honesty shown → trust → library → close
 *
 * - **The rail is the page.** Not one of Flo, Clue, Balance or Ovia markets
 *   continuity (§H.5); answering it would take Flo five more products and Ovia a
 *   different business model.
 * - **A product shot, because the market says so** (§H.1): Clue and Balance both
 *   lead with one, neither uses a mood image. It is drawn from the same tokens as
 *   the app so it cannot drift from what ships.
 * - **Honesty is shown, not claimed** — the band with its soft edges, the real
 *   no-late-counter copy, her own 30 days. The top reported complaint against the
 *   leaders is predictions collapsing for PCOS and perimenopause (§H.2).
 * - **The anti-claim sits in the hero.** Flo answers privacy with a certification;
 *   Femio answers structurally, and a structural claim beats a badge.
 *
 * Deliberately **server-rendered**: this is the SEO landing page and is not on the
 * tracker path, so `native-readiness-lint` does not apply to it.
 */

const STAGES = ["teen", "cycle", "ttc", "pregnancy", "postpartum", "menopause"] as const;
/**
 * `reviewed` leads (P1.9.8, 2026-08-16). R1.3b **removed** a clinician-review line
 * because it was not true: every byline read as nothing at all, since the importer
 * never set `authors` or `medicalReviewerProfile` and `Byline` correctly renders
 * nothing rather than inventing one. It is true now — 30 pages carry a named
 * reviewer with credentials, linked to a published bio, in the page and in the
 * `Article` schema — so the claim comes back, first, because `docs/03` §H.1 found
 * post-nominals on the page to be the strongest trust mechanism in the category.
 */
const TRUST = ["reviewed", "sources", "eu", "portable", "ads", "languages"] as const;
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

/**
 * The product shot: the real cycle dashboard, at rest.
 *
 * Every value here is a token the app itself uses — the hero gradient, the
 * prediction band with fading edges, the accent action, the tab bar — so a
 * marketing image cannot promise a screen the product does not have.
 */
async function ProductShot({ locale }: { locale: string }) {
  const t = await getTranslations({ locale, namespace: "home.shot" });
  return (
    <div className="mx-auto w-[232px] overflow-hidden rounded-lg border-[7px] border-text bg-bg shadow-lg">
      <div className="flex items-center justify-between border-b border-border bg-surface px-3 py-2">
        {/* Always English "femio", in every locale — product rule 6. */}
        <span className="font-display text-xs font-semibold text-primary">femio</span>
        <span className="size-3 rounded-round bg-surface-sunken" aria-hidden />
      </div>

      <div className="flex flex-col gap-2 px-3 pt-3">
        <div className="flex items-center gap-2">
          <span className="text-2xs font-semibold text-text">{t("app.title")}</span>
          <span className="rounded-pill bg-primary-soft px-2 py-0.5 text-[8px] font-semibold text-primary-soft-text">
            {t("app.mode")}
          </span>
        </div>

        <div className="flex flex-col gap-1.5 rounded-md bg-gradient-hero-cycle p-3 text-text-on-brand shadow-sm">
          <span className="text-[8px] font-semibold uppercase tracking-wider opacity-90 rtl:normal-case rtl:tracking-normal">
            {t("app.eyebrow")}
          </span>
          <span className="font-display text-sm leading-tight rtl:font-bold">
            {t("app.headline")}
          </span>
          {/* The band: soft edges, because the window has soft boundaries. */}
          <span className="relative block h-1.5 rounded-pill bg-white/25" aria-hidden>
            <span className="absolute inset-y-0 start-[32%] w-[40%] rounded-pill bg-[linear-gradient(90deg,transparent,currentColor_35%,currentColor_65%,transparent)]" />
            <span className="absolute -inset-y-0.5 start-[52%] w-0.5 rounded-pill bg-current" />
          </span>
          <span className="text-[8px] opacity-90">{t("app.foot")}</span>
        </div>

        <span className="grid min-h-7 place-items-center rounded-pill bg-accent-solid text-[10px] font-semibold text-accent-fg-solid">
          {t("app.cta")}
        </span>

        <div className="rounded-sm bg-surface p-2.5 shadow-xs">
          <span className="block text-[8px] text-text-muted">{t("app.avgLabel")}</span>
          <span className="font-display text-xs text-text">{t("app.avgValue")}</span>
        </div>
      </div>

      <div className="mt-2 flex justify-around border-t border-border bg-surface pb-2.5 pt-2">
        {(["home", "track", "settings"] as const).map((k, i) => (
          <span
            key={k}
            className={`flex flex-col items-center gap-0.5 text-[7px] ${
              i === 0 ? "text-primary" : "text-text-subtle"
            }`}
          >
            <span
              className={`h-3 w-6 rounded-pill ${i === 0 ? "bg-primary-soft" : ""}`}
              aria-hidden
            />
            {t(`app.tab.${k}`)}
          </span>
        ))}
      </div>
    </div>
  );
}

export default async function HomePage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("home");

  return (
    <main className="flex w-full flex-1 flex-col">
      <PageView area="home" />
      <JsonLd data={websiteJsonLd(locale)} />
      <JsonLd data={organizationJsonLd()} />

      {/* ── Hero — the one raised element on the page ───────────────────────── */}
      <section className="aurora text-text-on-brand">
        {/* `--gradient-dawn` runs out to amber, where white body copy measures
            2.15:1. So dawn is the signature, not the backdrop: a bar carrying no
            text over an AA-safe violet field (docs/25 §5a). */}
        <div className="absolute inset-x-0 top-0 h-1.5 bg-gradient-dawn" aria-hidden />
        <div className="mx-auto flex w-full max-w-3xl flex-col gap-4 px-6 pb-16 pt-14">
          <h1 className="font-display text-2xl leading-tight sm:text-3xl rtl:text-xl rtl:font-bold rtl:leading-relaxed">
            {t("heroTitle")}
          </h1>
          <p className="text-sm leading-relaxed opacity-95">{t("heroBody")}</p>

          <div className="mt-2 flex flex-col gap-3 sm:flex-row">
            {/* Accent = "act". Repeated at the close because it is the same action,
                not a second competing one (docs/25 §5a). */}
            <Button asChild variant="accent" size="lg" className="w-full sm:w-auto">
              <Link href={webAppEnabled() ? "/welcome" : APP_PAGE}>{t("cta")}</Link>
            </Button>
            <Button
              asChild
              variant="outline"
              size="lg"
              className="w-full border-white/55 bg-transparent text-text-on-brand hover:bg-white/10 sm:w-auto"
            >
              <Link href="/learn">{t("ctaSecondary")}</Link>
            </Button>
          </div>

          <p className="mt-4 border-t border-white/25 pt-4 text-2xs leading-relaxed opacity-90">
            {t("antiClaim")}
          </p>
        </div>
      </section>

      {/* ── The product, because Clue and Balance both lead with one ────────── */}
      <Section sunken>
        <Eyebrow>{t("shot.eyebrow")}</Eyebrow>
        <h2 className="font-display text-lg text-text rtl:font-bold">{t("shot.heading")}</h2>
        <ProductShot locale={locale} />
        {/* `--text-subtle` on `--surface-sunken` measures 4.47:1 — it was verified
            against `--bg` (4.81) and nobody checked it against a sunken section.
            Caught by axe, not by eye. `--text-muted` is 4.73 here. The token pairing
            itself is logged on P1.5.2. */}
        <p className="mt-2 text-center text-2xs leading-relaxed text-text-muted">
          {t("shot.caption")}
        </p>
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

      {/* ── Trust: five verifiable facts, not badges ────────────────────────── */}
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
          {SECTIONS.map((s) => (
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
          <h2 className="font-display text-lg text-text rtl:font-bold">{t("close.heading")}</h2>
          <Button asChild variant="accent" size="lg" className="w-full sm:w-auto">
            <Link href={webAppEnabled() ? "/welcome" : APP_PAGE}>{t("cta")}</Link>
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
